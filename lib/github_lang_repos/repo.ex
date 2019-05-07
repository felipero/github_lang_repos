defmodule GithubLangRepos.Repo do
  use Ecto.Repo,
    otp_app: :github_lang_repos,
    adapter: Ecto.Adapters.Postgres
end
