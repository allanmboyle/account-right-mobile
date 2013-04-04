class ContactController < ApplicationController

  def index
    respond_to_json do
      customer_file = AccountRight::CustomerFile.new(session[:cf_id])
      render :json => customer_file.contacts(@user_tokens).to_json
    end
  end

end
