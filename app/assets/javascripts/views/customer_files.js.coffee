define([ "backbone", "jquery", "underscore", "models/customer_files", "text!views/customer_files.html" ], (Backbone, $, _, CustomerFiles, ViewHtml) ->
  Backbone.View.extend(
    initialize: () ->
      $("body").append("<div id='customer-files' data-role='page'></div>")
      @customerFiles = new CustomerFiles()
      @template = _.template(ViewHtml)

    show: () ->
      @customerFiles.on('reset', @render, this)
      @customerFiles.fetch()

    render: () ->
      $("#customer-files-page").html(@template(customerFiles: @customerFiles))
      $.mobile.changePage("#customer-files" , reverse: false, changeHash: false)
      this
  )
)
