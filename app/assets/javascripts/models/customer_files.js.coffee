define([ "backbone", "models/customer_file" ], (Backbone, CustomerFile) ->

  class CustomerFiles extends Backbone.Collection

    model: CustomerFile,

    url: "/customer_files"

)
