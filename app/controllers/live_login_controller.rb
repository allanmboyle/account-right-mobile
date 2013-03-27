class LiveLoginController < ApplicationController
  include AuthenticationController

  def show
    recreate_session
  end

  def login
    respond_to_authentication do
      user = AccountRight::LiveUser.new(username: params[:emailAddress], password: params[:password])
      result = user.login
      session.update(access_token: result[:access_token], refresh_token: result[:refresh_token])
    end
  end

end
