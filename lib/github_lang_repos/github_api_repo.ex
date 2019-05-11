defmodule GithubLangRepos.GithubApiRepo do
  def get_language_top_five_repositories(language_name) do
    token = Application.get_env(:github_lang_repos, GithubLangRepos.Repo)[:github_token]
    client = Tentacat.Client.new(%{access_token: token})
    query = [q: "language:#{language_name}", per_page: 5, sort: "stars", order: "desc"]

    case Tentacat.Search.repositories(client, query, pagination: :none) do
      {200, response, http_response} ->
        {:ok, response["items"]}

      {status, response, http_response} ->
        {:error, status, response["errors"]}
    end
  end
end
