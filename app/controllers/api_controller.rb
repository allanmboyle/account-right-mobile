class ApiController < ApplicationController

  def invoke
    respond_to do |format|
      format.json  { render :json => AccountRight::API.invoke(request[:resource_path], session[:access_token]) }
    end
  end

end
