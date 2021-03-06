define([ "jquery",
         "underscore",
         "./base/view",
         "./filters/require_live_login",
         "../models/customer_files",
         "../models/customer_file_user",
         "text!./customer_files.tmpl",
         "text!./customer_files_login.tmpl" ], ($, _, BaseView, RequireLiveLoginFilter,
                                                CustomerFiles, CustomerFileUser,
                                                Template, LoginTemplate) ->

  $("body").append("<div id='customer-files' data-role='page' data-title='Customer Files'></div>")

  class CustomerFilesView extends BaseView

    initialize: (applicationState) ->
      super(applicationState, [ new RequireLiveLoginFilter() ])
      @compiledTemplate = _.template(Template)
      @compiledLoginTemplate = _.template(LoginTemplate)
      @customerFiles = new CustomerFiles().on("reset", @render, this)
                                          .on("error", @render, this)
      @customerFileUser = new CustomerFileUser().on("login:success", @loginSuccess, this)
                                                .on("login:fail", @loginFail, this)
                                                .on("login:error", @loginError, this)

    el: $("#customer-files")

    additionalEvents:
      "pagebeforeshow": "_pageBeforeShow"
      "pageshow": "_showErrorIfNecessary"
      "click #customer-file-login-submit": "login"

    update: () ->
      @customerFiles.fetch()

    prepareDom:() ->
      @$el.html(@compiledTemplate(header: @_headerContent(), customerFiles: @customerFiles))
      @_loginContent().hide().append(@compiledLoginTemplate)

    login: (event) ->
      @syncUser()
      @customerFiles.login(@customerFileUser)
      event.preventDefault()

    syncUser: () ->
      @customerFileUser.set(username: $("#customer-file-username").val(), password: $("#customer-file-password").val())

    loginSuccess: (customerFile) ->
      @applicationState.openedCustomerFile = customerFile
      location.hash = "contacts"

    loginFail: () ->
      $("#customer-file-login-fail-message").popup("open")

    loginError: () ->
      $("#customer-file-login-error-message").popup("open")

    _headerContent: () ->
      @renderHeader(
        button: { elementId: "live-logout", href: "#live_login", label: "Logout" },
        title: { label: "Log in to file" }
      )

    _pageBeforeShow: () ->
      @_showLoginAndUpdateModelWhenFileIsExpanded()
      @_showInitialLoginIfNecessary()
      @_showReLoginMessageIfNecessary()
      @_showNoFilesMessageIfNecessary()

    _showLoginAndUpdateModelWhenFileIsExpanded: () ->
      $(".customer-file").on("expand", (event) =>
        collapsible_content_element = $(event.target).find(".ui-collapsible-content")
        collapsible_content_element.append(@_loginContent().show())
        @customerFiles.expandedPosition = $(".ui-collapsible-content").index(collapsible_content_element)
      )

    _showInitialLoginIfNecessary: () ->
      $(".customer-file:first-child").trigger("expand") if @customerFiles.length == 1

    _showReLoginMessageIfNecessary: () ->
      message = $("#customer-file-re-login-required-message")
      if @applicationState.reLoginRequired then message.show() else message.hide()
      @applicationState.reLoginRequired = false

    _showNoFilesMessageIfNecessary: () ->
      if @customerFiles.isEmpty() then @_noFilesMessage().show() else @_noFilesMessage().hide()

    _showErrorIfNecessary: () ->
      $("#customer-files-general-error-message").popup("open") if @customerFiles.fetchError

    _loginContent: () ->
      $("#customer-file-login-content")

    _noFilesMessage: () ->
      $("#no-customer-files-message")

)
