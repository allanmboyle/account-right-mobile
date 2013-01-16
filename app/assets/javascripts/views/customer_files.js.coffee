define([ "backbone", "jquery", "underscore", "models/customer_files", "text!views/customer_files.html" ], (Backbone, $, _, CustomerFiles, ViewHtml) ->

  $("body").append("<div id='customer_files' data-role='page'></div>")

  Backbone.View.extend(

    initialize: () ->
      @template = _.template(ViewHtml)
      @customerFiles = new CustomerFiles()
      @customerFiles.on('reset', @render, this)

    el: $("#customer_files")

    update: () ->
      @customerFiles.fetch()

    render: () ->
      console.log("rendering customer files")
      @$el.html(@template(customerFiles: @customerFiles))
      $.mobile.changePage("#customer_files", reverse: false, changeHash: true)
      this

  )
)
