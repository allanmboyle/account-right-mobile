class CustomerFileController < ApplicationController
  include AuthenticationController

  def index
    respond_to_json do
      recreate_session_with(access_token: session[:access_token], refresh_token: session[:refresh_token])
      response = AccountRight::API.invoke("accountright", access_token: session[:access_token])
      render :json => response
    end
  end

  def login
    respond_to_authentication do
      user = AccountRight::CustomerFileUser.new(username: params[:username], password: params[:password])
      user.login(params[:fileId], session[:access_token])
      session[:cf_token] = user.cf_token
    end
  end

end
