define([ "backbone",
         "jquery",
         "underscore",
         "../models/customer_files",
         "text!./customer_files_layout.tmpl",
         "text!./customer_files_content.tmpl",
         "text!./login_content.tmpl" ], (Backbone, $, _, CustomerFiles, LayoutTemplate,
                                         ContentTemplate, LoginContentTemplate) ->

  $("body").append("<div id='customer_files' data-role='page' data-title='Customer Files'></div>")

  class CustomerFilesView extends Backbone.View

    initialize: () ->
      @compiledContentTemplate = _.template(ContentTemplate)
      @customerFiles = new CustomerFiles()
      @customerFiles.on('reset', @render, this)
      @$el.html(_.template(LayoutTemplate))
      @_loginContent().hide().append(_.template(LoginContentTemplate, type : "customer_file"))

    el: $("#customer_files")

    events: () ->
      "click #customer_file_login_submit": "login"

    update: () ->
      @customerFiles.fetch()

    render: () ->
      view = this
      $("#customer-files-content").html(@compiledContentTemplate(customerFiles: @customerFiles))
      $(".customer-file").on("expand", (event) ->
        view._collapsibleContentFor(event).append(view._loginContent().show())
      )
      $.mobile.changePage("#customer_files", reverse: false, changeHash: false)
      this

    login: (event) ->
      location.hash = "contacts"
      event.preventDefault()

    _loginContent: () ->
      $("#customer-file-login-content")

    _collapsibleContentFor: (event) ->
      $(event.target).find(".ui-collapsible-content")

)
