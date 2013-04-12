class WelcomeController < ApplicationController

  def index
    @opened_customer_file = begin
      AccountRight::CustomerFile.find(@client_application_state)
    rescue AccountRight::API::Exception
      "{}"
    end
  end

end
