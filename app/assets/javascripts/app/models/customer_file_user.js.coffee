define([ "backbone", "underscore", "./ajax" ], (Backbone, _, Ajax) ->

  class CustomerFileUser extends Backbone.Model

    defaults: {
      username: "Not specified"
      password: "Not specified"
    }

    loginTo: (customerFile) ->
      Ajax.submit(
        type: "POST"
        url: "/customer_file/login",
        data: _.extend({ fileId: customerFile.get("Id") }, @attributes)
        success: () => @trigger("login:success", customerFile)
        error: (jqXHR) =>
          eventToTrigger = if jqXHR.status == 401 then "fail" else "error"
          @trigger("login:#{eventToTrigger}")
      )

)
