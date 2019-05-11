defmodule GithubLangRepos.Github do
  import Ecto.Query, warn: false

  alias GithubLangRepos.{
    Github.Repository,
    Github.Language,
    GithubApiRepo,
    Repo
  }

  def get_from_github([language_name | tail]) do
    case GithubApiRepo.get_language_top_five_repositories(language_name) do
      {:ok, repos} ->
        language_changeset = Repo.get_by(Language, name: language_name) || %Language{}

        changeset = Language.changeset(language_changeset, %{name: language_name})

        language =
          case(Repo.insert_or_update(changeset)) do
            {:ok, lang} ->
              create_repositories_from_github_data(lang, repos)

              Repo.preload(lang,
                repositories: from(r in Repository, order_by: [desc: :stars_count])
              )

            {:error, error} ->
              IO.inspect(error)
              nil
          end

        [language] ++ get_from_github(tail)

      {:error, status, errors} ->
        IO.inspect(errors)
    end
  end

  def get_from_github([]), do: []

  defp create_repositories_from_github_data(language, [repo | repos]) do
    changeset =
      Repository.changeset(%Repository{}, repo)
      |> Ecto.Changeset.put_assoc(:language, language)

    case Repo.insert(changeset, on_conflict: :replace_all, conflict_target: :full_name) do
      {:ok, repository} ->
        [repository] ++ create_repositories_from_github_data(language, repos)

      {:error, error} ->
        IO.inspect(error)
    end
  end

  defp create_repositories_from_github_data(language, []), do: []

  def get_repository!(id), do: GithubLangRepos.Repo.get!(Repository, id)
end
