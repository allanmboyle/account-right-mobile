class ApiController < ApplicationController

  def invoke
    respond_to_json do
      response = AccountRight::API.invoke(request[:resource_path], session[:access_token], session[:cftoken] || nil)
      render :json => response
    end
  end

end
