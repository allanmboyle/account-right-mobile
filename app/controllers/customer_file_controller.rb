class CustomerFileController < ApplicationController
  include AuthenticationController

  def index
    respond_to_json do
      recreate_session_with(access_token: session[:access_token], refresh_token: session[:refresh_token])
      response = AccountRight::API.invoke("accountright", AccountRight::UserTokens.new(session))
      render :json => response
    end
  end

  def login
    respond_to_authentication do
      user = AccountRight::CustomerFileUser.new(username: params[:username], password: params[:password])
      user.login(AccountRight::CustomerFile.new(params[:fileId]), @user_tokens)
      @user_tokens.save
      session[:cf_id] = params[:fileId]
    end
  end

end
