class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :establish_client_application_state

  rescue_from Exception, with: :handle_unexpected_exception

  private

  def establish_client_application_state
    @client_application_state = AccountRightMobile::ClientApplicationState.new(session)
  end

  def require_live_login
    unless @client_application_state.logged_in_to_live?
      respond_to_json { render json: { liveLoginRequired: true }, status: 401 }
    end
  end

  def handle_unexpected_exception(exception)
    Rails.logger.error("An unexpected exception occurred: #{exception.class.name} #{exception}")
    respond_to_json { render json: exception.message, status: 500 }
  end

  def respond_to_json
    respond_to do |format|
      format.json { yield }
    end
  end

  def default_json_response
    { "csrf-token" => form_authenticity_token }
  end

end
