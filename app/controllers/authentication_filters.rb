module AuthenticationFilters

  def require_live_login
    unless @client_application_state.logged_in_to_live?
      respond_to_json { render json: { loginRequired: :live_login }, status: 401 }
    end
  end

  def require_customer_file_login
    unless @client_application_state.logged_in_to_customer_file?
      respond_to_json { render json: { loginRequired: :customer_files }, status: 401 }
    end
  end

end
