class AuthenticationController < ApplicationController

  def live_login
    respond_to do |format|
      format.json  { render :json => {}.to_json }
    end
  end

end
