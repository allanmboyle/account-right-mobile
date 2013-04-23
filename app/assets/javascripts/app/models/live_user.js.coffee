define([ "backbone" ], (Backbone) ->

  class LiveUser extends Backbone.Model

    defaults: {
      emailAddress: ""
      password: ""
    }

    initialize: () ->
      @isLoggedIn = window.isLoggedInToLive

    reset: () ->
      Backbone.ajax(
        type: "GET"
        url: "/live_user/reset"
        success: () =>
          @isLoggedIn = false
          @trigger("reset:success")
        error: () => @trigger("reset:error")
      )

    login: () ->
      Backbone.ajax(
        type: "POST"
        url: "/live_user/login"
        data: @attributes
        success: () =>
          @isLoggedIn = true
          @trigger("login:success")
        error: (jqXHR) =>
          eventToTrigger = if jqXHR.status == 401 then "fail" else "error"
          @trigger("login:#{eventToTrigger}")
      )

)
