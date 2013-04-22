class TestableApplicationController < ApplicationController

  before_filter :require_live_login, only: :action_requiring_live_login

  def empty_action
    render :nothing => true
  end

  def action_requiring_live_login
    respond_to_json { render :json => "Normal body" }
  end

  def respond_to_json_action
    respond_to_json { render :json => "Some JSON" }
  end

  def action_causing_exception
    raise Exception, "Some general exception"
  end

  def action_with_default_json_response
    respond_to_json { render :json => default_json_response }
  end

end
