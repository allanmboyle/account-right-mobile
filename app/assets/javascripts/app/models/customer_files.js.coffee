define([ "backbone", "./customer_file" ], (Backbone, CustomerFile) ->

  class CustomerFiles extends Backbone.Collection

    model: CustomerFile

    url: "/api/accountright"

    expandedFile: () ->
      @at(@expandedPosition)

    login: (customerFileUser) ->
      customerFileUser.loginTo(@expandedFile())

)
