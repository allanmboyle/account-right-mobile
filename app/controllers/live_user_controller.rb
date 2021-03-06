class LiveUserController < ApplicationController
  include AuthenticationController

  def reset
    respond_to_json do
      recreate_session
      render json: default_json_response
    end
  end

  def login
    respond_to_authentication do
      user = AccountRight::LiveUser.new(username: params[:emailAddress], password: params[:password])
      result = user.login
      @client_application_state.save(access_token: result[:access_token], refresh_token: result[:refresh_token])
    end
  end

end
