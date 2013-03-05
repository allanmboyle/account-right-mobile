define([ "backbone" ], (Backbone) ->

  class LiveUser extends Backbone.Model

    defaults: {
      username: "Not specified",
      password: "Not specified"
    }

    login: () ->
      user = this
      Backbone.ajax(
        type: "POST"
        url: "/live_login",
        data: user.attributes
        success: () -> user.trigger("login:success")
        error: (jqXHR) ->
          eventToTrigger = if jqXHR.status == 400 then "fail" else "error"
          user.trigger("login:#{eventToTrigger}")
      )

)
