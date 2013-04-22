define([], () ->

  class RequireLiveLogin

    filter: (view) ->
      if (!view.applicationState.isLoggedInToLive())
        view.applicationState.reLoginRequired = true
        location.hash = "#live_login"
        false
      else
        true

)
