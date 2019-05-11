defmodule GithubLangReposWeb.Router do
  use GithubLangReposWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", GithubLangReposWeb do
    pipe_through(:browser)

    get("/", LanguageController, :index)
    resources("/repositories", RepositoryController, only: [:show])
  end

  # Other scopes may use custom stacks.
  # scope "/api", GithubLangReposWeb do
  #   pipe_through :api
  # end
end
