define([ "backbone", "./ajax" ], (Backbone, Ajax) ->

  class LiveUser extends Backbone.Model

    defaults: {
      emailAddress: "Not specified"
      password: "Not specified"
    }

    reset: () ->
      Ajax.submit(
        type: "GET"
        url: "/live_user/reset"
        success: () => @trigger("reset:success")
        error: () => @trigger("reset:error")
      )

    login: () ->
      Ajax.submit(
        type: "POST"
        url: "/live_user/login"
        data: @attributes
        success: () => @trigger("login:success")
        error: (jqXHR) =>
          eventToTrigger = if jqXHR.status == 401 then "fail" else "error"
          @trigger("login:#{eventToTrigger}")
      )

)
