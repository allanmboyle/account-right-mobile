class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :establish_client_application_state

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
    { "csrf-token" => form_authenticity_token }.to_json
  end

end
