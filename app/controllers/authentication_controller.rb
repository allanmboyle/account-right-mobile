module AuthenticationController

  private

  def recreate_session_with(hash={})
    new_session_hash = { _csrf_token: session[:_csrf_token] }.merge!(hash)
    reset_session
    session.update(new_session_hash)
  end

  alias_method :recreate_session, :recreate_session_with

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
