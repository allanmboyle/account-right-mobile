define([ "backbone", "underscore", "./ajax" ], (Backbone, _, Ajax) ->

  class CustomerFileUser extends Backbone.Model

    defaults: {
      username: "Not specified"
      password: "Not specified"
    }

    loginTo: (customerFile) ->
      user = this
      Ajax.submit(
        type: "POST"
        url: "/customer_file/login",
        data: _.extend({ fileId: customerFile.get("Id") }, user.attributes)
        success: () -> user.trigger("login:success")
        error: (jqXHR) ->
          eventToTrigger = if jqXHR.status == 401 then "fail" else "error"
          user.trigger("login:#{eventToTrigger}")
      )

)
