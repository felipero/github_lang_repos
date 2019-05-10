defmodule GithubLangRepos.GithubTest do
  use GithubLangRepos.DataCase

  alias GithubLangRepos.Github

  describe "Github context" do
    alias GithubLangRepos.Github.Language
    alias GithubLangRepos.Github.Repository

    @valid_attrs %{name: "some name"}
    @invalid_attrs %{name: nil}

    @valid_repository_attrs %{
      name: "Tetris",
      full_name: "dtrupenn/Tetris",
      private: false,
      html_url: "https://github.com/dtrupenn/Tetris",
      api_url: "https://api.github.com/repos/dtrupenn/Tetris",
      github_created_at: "2012-01-01T00:31:50Z",
      size: 524,
      stars_count: 1,
      watchers_count: 1,
      forks_count: 0,
      score: 10.309712,
      owner: %{
        "login" => "dtrupenn",
        "avatar_url" => "https://secure.gravatar.com/avatar/e7956084e75f239de85d3a31bc172ace",
        "gravatar_id" => "",
        "url" => "https://api.github.com/users/dtrupenn",
        "received_events_url" => "https://api.github.com/users/dtrupenn/received_events",
        "type" => "User"
      }
    }

    def language_fixture(attrs \\ %{}) do
      {:ok, language} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Github.create_language()

      language
    end

    def repository_fixture(attrs \\ %{}) do
      {:ok, repository} =
        attrs
        |> Enum.into(@valid_repository_attrs)
        |> Github.create_repository()

      repository
    end

    test "list_languages/0 returns all languages" do
      language = language_fixture()
      assert Github.list_languages() == [language]
    end

    test "create_language/1 with valid data creates a language" do
      assert {:ok, %Language{} = language} = Github.create_language(@valid_attrs)
      assert language.name == "some name"
    end

    test "create_language/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Github.create_language(@invalid_attrs)
    end

    test "delete_language/1 deletes the language" do
      language = language_fixture()
      assert {:ok, %Language{}} = Github.delete_language(language)
      assert_raise Ecto.NoResultsError, fn -> GithubLangRepos.Repo.get!(Language, language.id) end
    end

    test "get_repo!/1 returns the repo with given id" do
      language = language_fixture()
      repository = repository_fixture(language: language)
      assert Github.get_repository!(repository.id) == repository
    end

    test "create_repo/1 with valid data creates a repo" do
      assert {:ok, %Repository{} = repository} = Github.create_repository(@valid_repository_attrs)
      assert repository.name == "Tetris"
    end

    test "create_repo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Github.create_repository(@invalid_attrs)
    end
  end
end
