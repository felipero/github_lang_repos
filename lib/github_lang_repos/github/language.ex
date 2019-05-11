defmodule GithubLangRepos.Github.Language do
  use Ecto.Schema
  import Ecto.Changeset

  alias GithubLangRepos.{
    Github.Repository
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "languages" do
    field(:name, :string)

    has_many(:repositories, Repository)

    timestamps()
  end

  @doc false
  def changeset(language, attrs) do
    language
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
