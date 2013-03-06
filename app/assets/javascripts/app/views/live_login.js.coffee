define([ "backbone",
         "jquery",
         "underscore",
         "text!./live_login_layout.tmpl",
         "text!./login_content.tmpl",
         "app/models/live_user" ], (Backbone, $, _, LayoutTemplate, ContentTemplate, LiveUser) ->

  $("body").append("<div id='live_login' data-role='page' data-title='AccountRight Live Login'></div>")

  class LiveLoginView extends Backbone.View

    initialize: () ->
      @user = new LiveUser()
      @user.on("login:success", @success, this)
      @user.on("login:fail", @fail, this)
      @user.on("login:error", @error, this)
      @$el.html(_.template(LayoutTemplate))
      $("#live-login-content").html(_.template(ContentTemplate, type : "live"))
      @$el.on("pageshow", () -> $("#live_username").focus())

    el: $("#live_login")

    events: () ->
      "click #live_login_submit": "login"

    render: () ->
      $.mobile.changePage("#live_login", reverse: false, changeHash: false)
      this

    login: (event) ->
      @syncUser()
      @user.login()
      event.preventDefault()

    success: () ->
      location.hash = "customer_files"

    fail: () ->
      $("#live_login_fail_message").popup().popup("open")

    error: () ->
      $("#live_login_error_message").popup().popup("open")

    syncUser: () ->
      @user.set(username: $("#live_username").val(), password: $("#live_password").val())

)
