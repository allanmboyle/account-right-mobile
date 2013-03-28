define([ "backbone",
         "jquery",
         "underscore",
         "text!./live_login.tmpl",
         "app/models/live_user" ], (Backbone, $, _, Template, LiveUser) ->

  $("body").append("<div id='live_login' data-role='page' data-title='AccountRight Live Login'></div>")

  class LiveLoginView extends Backbone.View

    initialize: () ->
      @user = new LiveUser().on("reset:success", @resetSuccess, this)
                            .on("reset:error", @resetError, this)
                            .on("login:success", @loginSuccess, this)
                            .on("login:fail", @loginFail, this)
                            .on("login:error", @loginError, this)
      @$el.html(_.template(Template))
      @$el.on("pageshow", () -> $("#live_email_address").focus())

    el: $("#live_login")

    events: () ->
      "click #live-login-submit": "login"

    render: () ->
      @user.reset()

    login: (event) ->
      @syncUser()
      @user.login()
      event.preventDefault()

    resetSuccess: () ->
      $.mobile.changePage("#live_login", reverse: false, changeHash: false)

    resetError: () ->
      $("#live-login-general-error-message").popup().popup("open")

    loginSuccess: () ->
      location.hash = "customer_files"

    loginFail: () ->
      $("#live-login-fail-message").popup().popup("open")

    loginError: () ->
      $("#live-login-error-message").popup().popup("open")

    syncUser: () ->
      @user.set(emailAddress: $("#live_email_address").val(), password: $("#live_password").val())

)
