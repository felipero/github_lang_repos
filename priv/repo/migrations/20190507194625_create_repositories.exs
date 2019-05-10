defmodule GithubLangRepos.Repo.Migrations.CreateRepositories do
  use Ecto.Migration

  def change do
    create table(:repositories, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string)
      add(:full_name, :string)
      add(:private, :boolean, default: false, null: false)
      add(:html_url, :string)
      add(:description, :text)
      add(:api_url, :string)
      add(:github_created_at, :utc_datetime)
      add(:size, :integer)
      add(:stars_count, :integer)
      add(:watchers_count, :integer)
      add(:forks_count, :integer)
      add(:score, :decimal)
      add(:owner, :map)
      add(:language_id, references(:languages, on_delete: :delete_all, type: :binary_id))

      timestamps()
    end

    create(index(:repositories, [:language_id]))
    create(unique_index(:repositories, [:full_name]))
  end
end
