class TravisController < ApplicationController
  respond_to :html, :js, :json, :text

  def index # GET collection
    travis_repos = Rails.cache.fetch('travis_repos', expires_in: 10.minutes) do
      Travis.repos.sort.map do |repo_name|
        Travis.status(repo_name)
      end
    end

    respond_with(travis_repos: travis_repos) do |format|
      format.html { render locals: { travis_repos: travis_repos }, layout: request.xhr? ? false : 'application' }
    end
  end
end
