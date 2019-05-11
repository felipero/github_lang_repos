defmodule GithubLangRepos.GithubApiRepo do
  def get_language_top_five_repositories(language_name) do
    client = Tentacat.Client.new(%{access_token: "bd8d280537fa130bee95473931d972db3c1a005d"})
    query = [q: "language:#{language_name}", per_page: 5, sort: "stars", order: "desc"]

    case Tentacat.Search.repositories(client, query, pagination: :none) do
      {200, response, _http_response} ->
        {:ok, response["items"]}

      {status, response, _http_response} ->
        {:error, status, response["errors"]}
    end
  end
end
