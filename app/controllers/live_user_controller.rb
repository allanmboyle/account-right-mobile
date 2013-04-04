class LiveUserController < ApplicationController
  include AuthenticationController

  def reset
    respond_to_json do
      recreate_session
      render :json => {}.to_json
    end
  end

  def login
    respond_to_authentication do
      user = AccountRight::LiveUser.new(username: params[:emailAddress], password: params[:password])
      result = user.login
      AccountRight::UserTokens.new(session)
                              .save(access_token: result[:access_token], refresh_token: result[:refresh_token])
    end
  end

end
