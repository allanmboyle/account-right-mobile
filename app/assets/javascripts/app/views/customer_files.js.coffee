define([ "backbone",
         "jquery",
         "underscore",
         "../models/customer_files",
         "text!./customer_files_layout.tmpl",
         "text!./customer_files_content.tmpl"], (Backbone, $, _, CustomerFiles, LayoutTemplate, ContentTemplate) ->

  $("body").append("<div id='customer_files' data-role='page' data-title='Customer Files'></div>")

  class CustomerFilesView extends Backbone.View

    initialize: () ->
      @$el.html(_.template(LayoutTemplate))
      @compiledContentTemplate = _.template(ContentTemplate)
      @customerFiles = new CustomerFiles()
      @customerFiles.on('reset', @render, this)

    el: $("#customer_files")

    update: () ->
      @customerFiles.fetch()

    render: () ->
      $("#customer-files-content").html(@compiledContentTemplate(customerFiles: @customerFiles))
      $.mobile.changePage("#customer_files", reverse: false, changeHash: false)
      @_repaintContent()
      this

    _repaintContent: () ->
      $("#customer-files-content").trigger('create')

)
