define([ "backbone",
         "jquery",
         "underscore",
         "../models/customer_files",
         "../models/customer_file_user",
         "text!./customer_files_layout.tmpl",
         "text!./customer_files_content.tmpl",
         "text!./customer_files_login.tmpl" ], (Backbone, $, _, CustomerFiles, CustomerFileUser,
                                                LayoutTemplate, ContentTemplate, LoginTemplate) ->

  $("body").append("<div id='customer_files' data-role='page' data-title='Customer Files'></div>")

  class CustomerFilesView extends Backbone.View

    initialize: () ->
      @compiledContentTemplate = _.template(ContentTemplate)
      @customerFiles = new CustomerFiles()
      @customerFileUser = new CustomerFileUser().on("login:success", @loginSuccess, this)
                                                .on("login:fail", @loginFail, this)
                                                .on("login:error", @loginError, this)
      @$el.html(_.template(LayoutTemplate))
      @_loginContent().hide().append(_.template(LoginTemplate))

    el: $("#customer_files")

    events: () ->
      "click #customer-file-login-submit": "login"
      "pagebeforeshow": "pageBeforeShow"
      "pageshow": "showErrorIfNecessary"

    update: () ->
      @customerFiles.on("reset", @render, this).on("error", @render, this)
      @customerFiles.fetch()

    render: () ->
      $("#customer-files-content").html(@compiledContentTemplate(customerFiles: @customerFiles))
      $.mobile.changePage("#customer_files", reverse: false, changeHash: false)
      this

    pageBeforeShow: () ->
      @_showLoginAndUpdateModelWhenFileIsExpanded()
      @_showInitialLoginIfNecessary()
      @_showNoFilesMessageIfNecessary()

    showErrorIfNecessary: () ->
      $("#customer-files-general-error-message").popup().popup("open") if @customerFiles.fetchError

    login: (event) ->
      @syncUser()
      @customerFiles.login(@customerFileUser)
      event.preventDefault()

    syncUser: () ->
      @customerFileUser.set(username: $("#customer-file-username").val(), password: $("#customer-file-password").val())

    loginSuccess: () ->
      location.hash = "contacts"

    loginFail: () ->
      $("#customer-file-login-fail-message").popup().popup("open")

    loginError: () ->
      $("#customer-file-login-error-message").popup().popup("open")

    _showLoginAndUpdateModelWhenFileIsExpanded: () ->
      view = this
      $(".customer-file").on("expand", (event) ->
        collapsible_content_element = $(event.target).find(".ui-collapsible-content")
        collapsible_content_element.append(view._loginContent().show())
        view.customerFiles.expandedPosition = $(".ui-collapsible-content").index(collapsible_content_element)
      )

    _showInitialLoginIfNecessary: () ->
      $(".customer-file:first-child").trigger("expand") if @customerFiles.length == 1

    _showNoFilesMessageIfNecessary: () ->
      if (@customerFiles.isEmpty()) then @_noFilesMessage().show() else @_noFilesMessage().hide()

    _loginContent: () ->
      $("#customer-file-login-content")

    _noFilesMessage: () ->
      $("#no-customer-files-message")

)
