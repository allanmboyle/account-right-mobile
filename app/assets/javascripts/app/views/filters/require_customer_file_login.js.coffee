define([], () ->

  class RequireCustomerFileLogin

    filter: (view) ->
      if (!view.applicationState.isLoggedInToCustomerFile())
        view.applicationState.reLoginRequired = true
        location.hash = "#customer_files"
        false
      else
        true

)
