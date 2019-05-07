defmodule GithubLangReposWeb.PageController do
  use GithubLangReposWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
