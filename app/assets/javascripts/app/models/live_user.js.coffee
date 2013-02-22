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
        success: (response) -> user.trigger("login:success", response)
        error: () -> user.trigger("login:fail")
      )

)
