class ApiController < ApplicationController

  def invoke
    respond_to_json do
      response = AccountRight::API.invoke(request[:resource_path], @user_tokens)
      render :json => response
    end
  end

end
