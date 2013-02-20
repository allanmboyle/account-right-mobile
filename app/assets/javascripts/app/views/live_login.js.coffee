
define([ "backbone",
         "jquery",
         "underscore",
         "text!./login.tmpl",
         "app/models/live_user" ], (Backbone, $, _, Template, LiveUser) ->

  $("body").append("<div id='live_login' data-role='page' data-title='AccountRight Live Login'></div>")

  class LiveLoginView extends Backbone.View

    initialize: () ->
      @user = new LiveUser()
      @user.on("login:success", @success, this)
      @$el.html(_.template(Template, title : "AccountRight Live Login", type : "live"))
      @$el.on("pageshow", () -> $("#live_username").focus())

    el: $("#live_login")

    events: () ->
      "click #live_login_submit": "login"

    render: () ->
      $.mobile.changePage("#live_login" , reverse: false, changeHash: false)
      this

    login: (event) ->
      @syncUser()
      @user.login()
      event.preventDefault()

    success: (response) ->
      location.hash = "customer_files"

    syncUser: () ->
      @user.set(username: $("#live_username").val(), password: $("#live_password").val())

)
