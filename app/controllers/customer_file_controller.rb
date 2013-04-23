class CustomerFileController < ApplicationController
  include AuthenticationController

  before_filter :require_live_login

  def index
    respond_to_json do
      recreate_session_with(access_token: session[:access_token], refresh_token: session[:refresh_token])
      response = AccountRight::CustomerFile.all(AccountRightMobile::ClientApplicationState.new(session))
      render json: response
    end
  end

  def login
    respond_to_authentication do
      user = AccountRight::CustomerFileUser.new(customer_file: AccountRight::CustomerFile.new(id: params[:fileId]),
                                                username: params[:username], password: params[:password])
      user.login(@client_application_state)
      @client_application_state.save
    end
  end

end
