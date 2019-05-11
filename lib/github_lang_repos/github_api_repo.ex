defmodule GithubLangRepos.GithubApiRepo do
  def get_language_top_five_repositories(language_name) do
    client = Tentacat.Client.new(%{access_token: "dbaff2cdc4f6d6a3ce90ce6263347a775c4acdc5"})
    query = [q: "language:#{language_name}", per_page: 5, sort: "stars", order: "desc"]

    case Tentacat.Search.repositories(client, query, pagination: :none) do
      {200, response, http_response} ->
        IO.inspect(http_response)
        {:ok, response["items"]}

      {status, response, _http_response} ->
        {:error, status, response["errors"]}
    end
  end
end
