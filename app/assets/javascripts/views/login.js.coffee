define([ "backbone", "jquery", "underscore", "text!views/login.html" ], (Backbone, $, _, ViewHtml) ->

  $("body").append(_.template(ViewHtml))

  Backbone.View.extend(

    el: $("#login")

    events: () ->
      "click #login-submit": "login"

    login: () ->
      router.navigate("customer_files", trigger: true)

    render: () ->
      setTimeout(() -> $("#username").focus())
      $.mobile.changePage("#login" , reverse: false, changeHash: true)
      this

  )
)
