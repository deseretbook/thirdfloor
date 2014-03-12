class TravisController < ApplicationController
  respond_to :html

  def index # GET collection
    render layout: choose_correct_template
  end

  def show
    repo_string = params.require(:repo_string)
    repo = Rails.cache.fetch("travis_#{repo_string}", expires_in: 5.minutes) do
      Travis.status(repo_string)
    end

    render partial: 'row', locals: { repo: repo }
  end
end
