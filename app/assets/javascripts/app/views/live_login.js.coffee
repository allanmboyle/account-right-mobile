define([ "backbone", "jquery", "underscore", "text!./login.tmpl" ], (Backbone, $, _, Template) ->

  $("body").append(_.template(Template, title : "Account Right Live Login", type : "live"))
  $("#live_login").on("pageshow", () -> $("#live_username").focus())

  class LiveLoginView extends Backbone.View

    el: $("#live_login")

    events: () ->
      "click #live_login_submit": "login"

    login: (event) ->
      location.hash = "customer_files"
      event.preventDefault()

    render: () ->
      $.mobile.changePage("#live_login" , reverse: false, changeHash: false)
      this

)
