class TestableApplicationController < ApplicationController

  def empty_action
    render :nothing => true
  end

  def respond_to_json_action
    respond_to_json { render :json => "Some JSON" }
  end

  def action_with_default_json_response
    respond_to_json { render :json => default_json_response }
  end

end
