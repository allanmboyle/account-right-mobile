define([ "backbone", "./ajax" ], (Backbone, Ajax) ->

  class LiveUser extends Backbone.Model

    defaults: {
      emailAddress: "Not specified"
      password: "Not specified"
    }

    reset: () ->
      user = this
      Ajax.submit(
        type: "GET"
        url: "/live_user/reset"
        success: () -> user.trigger("reset:success")
        error: () -> user.trigger("reset:error")
      )

    login: () ->
      user = this
      Ajax.submit(
        type: "POST"
        url: "/live_user/login"
        data: user.attributes
        success: () -> user.trigger("login:success")
        error: (jqXHR) ->
          eventToTrigger = if jqXHR.status == 401 then "fail" else "error"
          user.trigger("login:#{eventToTrigger}")
      )

)
