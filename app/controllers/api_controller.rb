class ApiController < ApplicationController

  def invoke
    respond_to_json do
      response = AccountRight::API.invoke(request[:resource_path], security_tokens)
      render :json => response
    end
  end

  private

  def security_tokens
    security_tokens = { access_token: session[:access_token] }
    security_tokens[:cf_token] = session[:cf_token] if session[:cf_token]
    security_tokens
  end

end
