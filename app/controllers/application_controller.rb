class ApplicationController < ActionController::Base
  protect_from_forgery

  def respond_to_json
    respond_to do |format|
      format.json do
        yield
      end
    end
  end

end
