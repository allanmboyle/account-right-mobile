class AuthenticationController < ApplicationController

  def live_login
    for_json_requests do
      if AccountRightMobile::Application.config.live_login["base_uri"]
        authenticate_live_login
      else
        render :json => "", :status => 200
      end
    end
  end

  def authenticate_live_login
    begin
      result = AccountRight::LiveUser.new(username: params[:username], password: params[:password]).login
      session[:access_token] = result[:access_token]
      render :json => {}.to_json
    rescue AccountRight::AuthenticationFailure
      render :json => "", :status => 400
    rescue AccountRight::AuthenticationError
      render :json => "", :status => 500
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
