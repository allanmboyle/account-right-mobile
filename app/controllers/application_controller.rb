class ApplicationController < ActionController::Base
  include AuthenticationFilters
  protect_from_forgery

  before_filter :establish_client_application_state

  rescue_from Exception, with: :handle_unexpected_exception

  private

  def establish_client_application_state
    @client_application_state = AccountRightMobile::ClientApplicationState.new(session)
  end

  def respond_to_json
    respond_to do |format|
      format.json { yield }
    end
  end

  def default_json_response
    { "csrf-token" => form_authenticity_token }
  end

  def handle_unexpected_exception(exception)
    exception_details = "#{exception.class.name} #{exception}\n#{exception.backtrace.join("\n")}"
    Rails.logger.error("An unexpected exception occurred: #{exception_details}")
    respond_to_json { render json: exception.message, status: 500 }
  end

end
