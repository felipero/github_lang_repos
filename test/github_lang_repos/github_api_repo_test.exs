defmodule GithubLangRepos.GithubApiRepoTest do
  use GithubLangRepos.DataCase
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias GithubLangRepos.GithubApiRepo

  describe "GithubApiRepo" do
    test "get_language_top_five_repositories/1 gets 5 repositories from the indicated language in github" do
      use_cassette "search#repositories#Go" do
        {:ok, repos} = GithubApiRepo.get_language_top_five_repositories("Rust")
        second_repo = Enum.at(repos, 0)
        assert second_repo["name"] == "996.ICU"
        assert second_repo["full_name"] == "996icu/996.ICU"
        assert second_repo["language"] == "Rust"
      end
    end

    test "get_language_top_five_repositories/1 with invalid language returns empty" do
      use_cassette "search#repositories#Golixir" do
        {:error, status, errors} = GithubApiRepo.get_language_top_five_repositories("Golixir")
        error = List.first(errors)
        assert status == 422
        assert error["message"] == "None of the search qualifiers apply to this search type."
        assert error["field"] == "q"
        assert error["code"] == "invalid"
      end
    end
  end
end
