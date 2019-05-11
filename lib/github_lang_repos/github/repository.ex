defmodule GithubLangRepos.Github.Repository do
  use Ecto.Schema
  import Ecto.Changeset

  alias GithubLangRepos.{
    Github.Language
    # Github.Repository,
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "repositories" do
    field(:api_url, :string)
    field(:description, :string)
    field(:forks_count, :integer)
    field(:full_name, :string)
    field(:github_created_at, :utc_datetime)
    field(:html_url, :string)
    field(:name, :string)
    field(:owner, :map)
    field(:private, :boolean, default: false)
    field(:score, :decimal)
    field(:size, :integer)
    field(:stars_count, :integer)
    field(:watchers_count, :integer)

    belongs_to(:language, Language)

    timestamps()
  end

  @allowed_fields [
    :name,
    :full_name,
    :private,
    :html_url,
    :description,
    :api_url,
    :github_created_at,
    :size,
    :stars_count,
    :watchers_count,
    :forks_count,
    :score,
    :owner
  ]

  def changeset(repository, attrs) do
    converted_attrs =
      Map.merge(attrs, %{
        api_url: attrs[:api_url] || attrs["url"],
        github_created_at: attrs[:github_created_at] || attrs["created_at"],
        stars_count: attrs[:stars_count] || attrs["stargazers_count"]
      })
      |> Map.new(fn {key, val} ->
        cond do
          is_atom(key) -> {key, val}
          true -> {String.to_atom(key), val}
        end
      end)

    repository
    |> cast(converted_attrs, @allowed_fields)
    |> validate_required([
      :name,
      :full_name,
      :private,
      :html_url,
      :api_url,
      :github_created_at,
      :size,
      :stars_count,
      :watchers_count,
      :forks_count,
      :score,
      :owner
    ])
    |> foreign_key_constraint(:language_id)
    |> unique_constraint(:full_name)
  end
end
