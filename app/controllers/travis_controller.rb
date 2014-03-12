class TravisController < ApplicationController
  respond_to :html, :json

  def index # GET collection
    travis_repos = Rails.cache.fetch('travis_repos', expires_in: 10.minutes) do
      Travis.repos.sort.map do |repo_name|
        Travis.status(repo_name)
      end
    end

    respond_with(travis_repos: travis_repos) do |format|
      format.html do
        render(
          locals: { travis_repos: travis_repos },
          layout: choose_correct_template
        )
      end
    end
  end
end
