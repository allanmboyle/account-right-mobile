define([ "backbone",
         "jquery",
         "underscore",
         "../models/customer_files",
         "text!./customer_files.tmpl" ], (Backbone, $, _, CustomerFiles, Template) ->

  $("body").append("<div id='customer_files' data-role='page' data-title='Customer Files'></div>")

  class CustomerFilesView extends Backbone.View

    initialize: () ->
      @compiledTemplate = _.template(Template)
      @customerFiles = new CustomerFiles()
      @customerFiles.on('reset', @render, this)

    el: $("#customer_files")

    update: () ->
      @customerFiles.fetch()

    render: () ->
      @$el.html(@compiledTemplate(customerFiles: @customerFiles))
      $.mobile.changePage("#customer_files", reverse: false, changeHash: false)
      this

)
