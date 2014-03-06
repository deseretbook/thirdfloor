class UsersController < ApplicationController
  respond_to :html, :js, :json, :text

  skip_before_filter :verify_authenticity_token

  def index # GET collection
    users = User.where(track_location: true)

    respond_with(users: users) do |format|
      format.html { render locals: { users: users } }
    end
  end
end
