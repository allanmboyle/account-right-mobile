define([ "jquery",
         "underscore",
         "./base/view",
         "text!./live_login.tmpl" ], ($, _, BaseView, Template) ->

  $("body").append("<div id='live-login' data-role='page' data-title='AccountRight Live log in'></div>")

  class LiveLoginView extends BaseView

    initialize: (applicationState) ->
      super
      @user = @applicationState.liveUser.on("reset:success", @render, this)
                                        .on("reset:error", @resetError, this)
                                        .on("login:success", @loginSuccess, this)
                                        .on("login:fail", @loginFail, this)
                                        .on("login:error", @loginError, this)
      @$el.html(_.template(Template,
                           header: @renderHeader(elementClass: "myob-homepage-header", title: { label: "Contacts" })))

    el: $("#live-login")

    events:
      "pagebeforeshow": "_showReLoginMessageIfNecessary"
      "pageshow": "_focusOnFirstFormElement"
      "click #live-login-submit": "login"

    reset: () ->
      @user.reset()

    login: (event) ->
      @syncUser()
      @user.login()
      event.preventDefault()

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

    _showReLoginMessageIfNecessary: () ->
      message = $("#live-re-login-required-message")
      if @applicationState.reLoginRequired then message.show() else message.hide()
      @applicationState.reLoginRequired = false

    _focusOnFirstFormElement: () ->
      $("#live_email_address").focus()

)
