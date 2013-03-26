class AuthenticationController < ApplicationController

  def live_login
    respond_to_authentication do
      user = AccountRight::LiveUser.new(username: params[:emailAddress], password: params[:password])
      result = user.login
      recreate_session_with(access_token: result[:access_token], refresh_token: result[:refresh_token])
    end
  end

  def customer_file_login
    respond_to_authentication do
      user = AccountRight::CustomerFileUser.new(username: params[:username], password: params[:password])
      user.login(params[:fileId], session[:access_token])
      recreate_session_with(cf_token: user.cf_token)
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

  def recreate_session_with(hash)
    resolved_hash = session.to_hash.symbolize_keys.tap { |hash| hash.delete(:session_id) }.merge(hash)
    reset_session
    session.update(resolved_hash)
  end

end
