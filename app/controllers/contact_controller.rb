class ContactController < ApplicationController

  before_filter :require_live_login

  def index
    respond_to_json do
      customer_file = AccountRight::CustomerFile.new(id: @client_application_state[:cf_id])
      render json: customer_file.contacts(@client_application_state)
    end
  end

end
