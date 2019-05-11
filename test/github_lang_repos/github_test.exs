defmodule GithubLangRepos.GithubTest do
  use GithubLangRepos.DataCase
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias GithubLangRepos.{
    Github,
    Github.Language,
    Github.Repository,
    Repo
  }

  @valid_repository_attrs %{
    name: "Tetris",
    full_name: "dtrupenn/Tetris",
    private: false,
    html_url: "https://github.com/dtrupenn/Tetris",
    api_url: "https://api.github.com/repos/dtrupenn/Tetris",
    github_created_at: "2012-01-01T00:31:50Z",
    size: 524,
    stars_count: 1,
    watchers_count: 1,
    forks_count: 0,
    score: 10.309712,
    owner: %{
      "avatar_url" => "https://avatars2.githubusercontent.com/u/4285147?v=4",
      "login" => "jwilm",
      "url" => "https://api.github.com/users/jwilm"
    }
  }

  def repository_fixture(language \\ %Language{name: "Elixir"}, attrs \\ %{}) do
    language = Repo.insert!(language)

    repository =
      %Repository{}
      |> Repository.changeset(Map.merge(@valid_repository_attrs, attrs))
      |> Ecto.Changeset.put_assoc(:language, language)
      |> Repo.insert!()

    repository
  end

  describe "get_from_github/1" do
    test "search in github api, adds to the DB and returns all languages" do
      use_cassette "Github#get_from_github#1", match_requests_on: [:query] do
        repository_fixture(%Language{name: "Go"}, %{full_name: "golang/go"})
        assert Repo.get_by!(Repository, full_name: "golang/go") != nil

        assert Enum.count(Github.get_from_github(["Rust", "Go", "Elixir"])) == 3

        golang =
          Language
          |> Repo.get_by!(name: "Go")
          |> Repo.preload(repositories: from(r in Repository, order_by: [desc: :stars_count]))

        assert golang.name == "Go"
        golang_repo1 = List.first(golang.repositories)
        assert golang_repo1.full_name == "golang/go"
        assert Enum.count(golang.repositories) == 5

        elixir =
          Language
          |> Repo.get_by!(name: "Elixir")
          |> Repo.preload(repositories: from(r in Repository, order_by: [desc: :stars_count]))

        assert elixir.name == "Elixir"
        elixir_repo1 = List.first(elixir.repositories)
        assert elixir_repo1.full_name == "elixir-lang/elixir"
        assert Enum.count(elixir.repositories) == 5

        rust =
          Language
          |> Repo.get_by!(name: "Rust")
          |> Repo.preload(repositories: from(r in Repository, order_by: [desc: :stars_count]))

        assert rust.name == "Rust"
        rust_repo1 = List.first(rust.repositories)
        assert rust_repo1.full_name == "996icu/996.ICU"
        assert Enum.count(rust.repositories) == 5
      end
    end
  end

  test "get_repo!/1 returns the repo with given id" do
    repository = repository_fixture()
    assert Github.get_repository!(repository.id) |> Repo.preload(:language) == repository
  end
end
