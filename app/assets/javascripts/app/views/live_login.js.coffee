define([ "backbone", "jquery", "underscore", "text!./login.tmpl" ], (Backbone, $, _, Template) ->

  $("body").append("<div id='live_login' data-role='page' data-title='AccountRight Live Login'></div>")

  class LiveLoginView extends Backbone.View

    initialize: () ->
      @$el.html(_.template(Template, title : "AccountRight Live Login", type : "live"))
      @$el.on("pageshow", () -> $("#live_username").focus())

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
