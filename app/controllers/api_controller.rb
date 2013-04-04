class ApiController < ApplicationController

  def invoke
    respond_to_json do
      response = AccountRight::API.invoke(request[:resource_path], @client_application_state)
      render :json => response
    end
  end

end
