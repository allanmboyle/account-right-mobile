class TestableApplicationController < ApplicationController

  def some_action
    respond_to_json { render :json => "Some JSON" }
  end

end
