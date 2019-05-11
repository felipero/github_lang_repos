defmodule GithubLangReposWeb.LanguageController do
  use GithubLangReposWeb, :controller

  alias GithubLangRepos.Github
  # alias GithubLangRepos.Github.Language

  def index(conn, params) do
    langs = params["search"]["selected_languages"] || "Go, Elixir, Rust"
    languages = Github.get_from_github(Enum.map(String.split(langs, ","), &String.trim/1))

    conn
    |> assign(:search, %{
      selected_languages: langs
    })
    |> render("index.html", languages: languages)
  end
end
