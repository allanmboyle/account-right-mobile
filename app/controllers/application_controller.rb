class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :establish_user_tokens

  def establish_user_tokens
    @user_tokens = AccountRight::UserTokens.new(session)
  end

  def respond_to_json
    respond_to do |format|
      format.json do
        yield
      end
    end
  end

end
