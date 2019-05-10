defmodule GithubLangRepos.Github.Repository do
  use Ecto.Schema
  import Ecto.Changeset

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
    field(:language_id, :binary_id)

    timestamps()
  end

  @doc false
  def changeset(repository, attrs) do
    repository
    |> cast(attrs, [
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
    ])
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
    |> unique_constraint(:full_name)
  end
end
