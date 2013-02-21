class AuthenticationController < ApplicationController

  def live_login
    for_json_requests do
      live_user = AccountRight::LiveUser.new(username: params[:username], password: params[:password])
      begin
        render :json => live_user.login.to_json
      rescue
        render :json => "", :status => 400
      end
    end
  end

  private

  def for_json_requests
    respond_to do |format|
      format.json do
        yield
      end
    end
  end

end
