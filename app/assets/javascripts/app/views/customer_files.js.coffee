define([ "backbone",
         "jquery",
         "underscore",
         "../models/customer_files",
         "text!./customer_files_layout.tmpl",
         "text!./customer_files_content.tmpl",
         "text!./customer_files_login.tmpl" ], (Backbone, $, _, CustomerFiles, LayoutTemplate,
                                                ContentTemplate, LoginTemplate) ->

  $("body").append("<div id='customer_files' data-role='page' data-title='Customer Files'></div>")

  class CustomerFilesView extends Backbone.View

    initialize: () ->
      @compiledContentTemplate = _.template(ContentTemplate)
      @customerFiles = new CustomerFiles()
      @$el.html(_.template(LayoutTemplate))
      @_loginContent().hide().append(_.template(LoginTemplate))

    el: $("#customer_files")

    events: () ->
      "click #customer_file_login_submit": "login"
      "pagebeforeshow": "pageBeforeShow"
      "pageshow": "showErrorIfNecessary"

    update: () ->
      @customerFiles.error = false
      @customerFiles.on("reset", @render, this).on("error", @error, this)
      @customerFiles.fetch()

    error: () ->
      @customerFiles.error = true
      @render()

    render: () ->
      $("#customer-files-content").html(@compiledContentTemplate(customerFiles: @customerFiles))
      $.mobile.changePage("#customer_files", reverse: false, changeHash: false)
      this

    pageBeforeShow: () ->
      @_showLoginWhenFileIsExpanded()
      @_showInitialLoginIfNecessary()
      @_showNoFilesMessageIfNecessary()

    showErrorIfNecessary: () ->
      $("#general_error_message").popup().popup("open") if @customerFiles.error

    login: (event) ->
      location.hash = "contacts"
      event.preventDefault()

    _showLoginWhenFileIsExpanded: () ->
      view = this
      $(".customer-file").on("expand", (event) ->
        view._collapsibleContentFor(event).append(view._loginContent().show())
      )

    _showInitialLoginIfNecessary: () ->
      $(".customer-file:first-child").trigger("expand") if @customerFiles.length == 1

    _showNoFilesMessageIfNecessary: () ->
      if (@customerFiles.length == 0)
        @_noFilesMessage().show()
      else
        @_noFilesMessage().hide()

    _loginContent: () ->
      $("#customer-file-login-content")

    _noFilesMessage: () ->
      $("#no-customer-files-message")

    _collapsibleContentFor: (event) ->
      $(event.target).find(".ui-collapsible-content")

)
