defmodule GithubLangReposWeb.RepositoryControllerTest do
  use GithubLangReposWeb.ConnCase

  alias GithubLangRepos.{
    Github.Language,
    Github.Repository,
    Repo
  }

  describe "show/2" do
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
        "avatar_url" => "https://avatars2.githubusercontent.com/u/4285147?v=4",
        "html_url" => "https://github.com/jwilm",
        "login" => "jwilm",
        "url" => "https://api.github.com/users/jwilm"
      }
    }

    defp repository_fixture(language \\ %Language{name: "Elixir"}, attrs \\ %{}) do
      language = Repo.insert!(language)

      repository =
        %Repository{}
        |> Repository.changeset(Map.merge(@valid_repository_attrs, attrs))
        |> Ecto.Changeset.put_assoc(:language, language)
        |> Repo.insert!()

      repository
    end

    test "Responds with repository info if the repository is found", %{conn: conn} do
      repo = repository_fixture()

      response =
        conn
        |> get(Routes.repository_path(conn, :show, repo.id))
        |> html_response(200)

      assert response =~ repo.full_name
      assert response =~ repo.html_url
      assert response =~ repo.owner["login"]
    end

    # test "Responds with a message indicating repository not found"
  end
end
