define([ "backbone", "underscore" ], (Backbone, _) ->

  class CustomerFileUser extends Backbone.Model

    defaults: {
      username: "Not specified",
      password: "Not specified"
    }

    loginTo: (customerFile) ->
      user = this
      Backbone.ajax(
        type: "POST"
        url: "/customer_file_login",
        data: _.extend({ fileId: customerFile.get("Id") }, user.attributes)
        success: () -> user.trigger("login:success")
        error: (jqXHR) ->
          eventToTrigger = if jqXHR.status == 400 then "fail" else "error"
          user.trigger("login:#{eventToTrigger}")
      )

)
