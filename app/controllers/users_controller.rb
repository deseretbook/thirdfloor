class UsersController < ApplicationController
  respond_to :html, :json

  def index # GET collection
    users = User.where(track_location: true)

    respond_with(users: users) do |format|
      format.html { render locals: { users: users } }
    end
  end

  def authenticate
    response = HTTParty.post(
      "https://bookshelf.deseretbook.com/api/v1/login_account.json",
      body: { email: params.require(:email), password: params.require(:password) }.to_json,
      headers:   {
        'Content-Type' => 'application/json',
        'Accepts' => 'application/json'
      }
    )

    if response.code.to_s !~ /^(1|2)\d{2}$/
      raise "FATAL: HTTP Error: #{response.code}\n#{response.body}"     
    end

    auth = JSON.parse(response.body)
    if auth['success'] == true
      # notice how we don't store anything useful here, this is totally
      # insecure!
      session[:logged_in] = auth["hash"]
      session[:email_address] = params[:email]
      flash[:notice] = "Logged In"
      if (dest = session.delete(:destination)).present?
        redirect_to dest
      else
        redirect_to root_path
      end
    else
      render action: :log_in, locals: { notice: auth['error']['message'] }
    end
  end

end
