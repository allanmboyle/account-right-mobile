class TestableAuthenticationFilters < ApplicationController

  before_filter :require_live_login, only: :action_requiring_live_login
  before_filter :require_customer_file_login, only: :action_requiring_customer_file_login

  def action_requiring_live_login
    respond_to_json { render :json => "Normal body" }
  end

  def action_requiring_customer_file_login
    respond_to_json { render :json => "Normal body" }
  end

end