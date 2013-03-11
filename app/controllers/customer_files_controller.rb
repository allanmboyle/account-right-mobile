class CustomerFilesController < ApplicationController

  def index
    respond_to do |format|
      format.json  { render :json => AccountRight::API.customer_files(session[:access_token]) }
    end
  end

end
