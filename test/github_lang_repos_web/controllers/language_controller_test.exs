defmodule GithubLangReposWeb.LanguageControllerTest do
  use GithubLangReposWeb.ConnCase
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  describe "index" do
    test "lists all languages", %{conn: conn} do
      use_cassette "LanguagesController#index", match_requests_on: [:query] do
        conn =
          get(conn, Routes.language_path(conn, :index), selected_languages: "Go, Elixir, Rust")

        response = html_response(conn, 200)
        assert response =~ "Rust"
        assert response =~ "Go"
        assert response =~ "Elixir"
      end
    end
  end
end
