define([ "backbone", "./ajax" ], (Backbone, Ajax) ->

  class LiveUser extends Backbone.Model

    defaults: {
      emailAddress: "Not specified"
      password: "Not specified"
    }

    initialize: () ->
      @isLoggedIn = window.isLoggedInToLive

    reset: () ->
      Ajax.submit(
        type: "GET"
        url: "/live_user/reset"
        success: () =>
          @isLoggedIn = false
          @trigger("reset:success")
        error: () => @trigger("reset:error")
      )

    login: () ->
      Ajax.submit(
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
