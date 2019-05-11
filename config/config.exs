# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :github_lang_repos,
  ecto_repos: [GithubLangRepos.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :github_lang_repos, GithubLangReposWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "M3TSglGF7RuiBZGTwFn7V7fsK3ksRJs3HNakfUhI5Tm37KTBLf1eQeV4Evd7204Q",
  render_errors: [view: GithubLangReposWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: GithubLangRepos.PubSub, adapter: Phoenix.PubSub.PG2]

config :github_lang_repos, GithubLangRepos.Repo, github_token: System.get_env("GITHUB_AUTH_TOKEN")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
