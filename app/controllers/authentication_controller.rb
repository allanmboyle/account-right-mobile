class AuthenticationController < ApplicationController

  def live_login
    respond_to_authentication do
      user = AccountRight::LiveUser.new(username: params[:emailAddress], password: params[:password])
      result = user.login
      session[:access_token] = result[:access_token]
    end
  end

  def customer_file_login
    respond_to_authentication do
      user = AccountRight::CustomerFileUser.new(username: params[:username], password: params[:password])
      user.login(params[:fileId], session[:access_token])
      session[:cftoken] = user.cftoken
    end
  end

  private

  def respond_to_authentication(&block)
    respond_to_json do
      begin
        block.call
        render :json => {}.to_json
      rescue AccountRight::AuthenticationFailure
        render :json => "", :status => 401
      rescue AccountRight::AuthenticationError
        render :json => "", :status => 500
      end
    end
  end

end
