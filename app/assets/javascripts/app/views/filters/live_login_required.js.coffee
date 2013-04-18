define([], () ->

  class LiveLoginRequiredFilter

    filter: (view) ->
      if (!view.applicationState.isLoggedInToLive())
        view.applicationState.reLoginRequired = true
        location.hash = "#live_login"
        false
      else
        true

)
