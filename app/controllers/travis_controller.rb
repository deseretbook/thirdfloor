class TravisController < ApplicationController
  respond_to :html

  def index # GET collection
    render layout: choose_correct_template
  end

  def show
    repo_string = params.require(:repo_string)
    newest_travis_event = if (dp = DataPoint.newest_for('travis'))
      dp.created_at.to_i
    else
      0
    end

    # add newest_travis_event so when travis posts a new data point, we know
    # refresh our cache (by having the cache key change). This was the cache
    # is refreshed when the travis status changes.
    cache_key = "travis_#{repo_string}_#{newest_travis_event}"
    repo = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      Travis.status(repo_string)
    end

    render partial: 'row', locals: { repo: repo }
  end
end
