defmodule GithubLangReposWeb.RepositoryController do
  use GithubLangReposWeb, :controller

  alias GithubLangRepos.{
    Github.Repository,
    Repo
  }

  def show(conn, params) do
    repository =
      Repo.get(Repository, params["id"])
      |> Repo.preload(:language)

    conn
    |> render("show.html", repository: repository)
  end
end
