define([ "./base_collection", "./customer_file" ], (BaseCollection, CustomerFile) ->

  class CustomerFiles extends BaseCollection

    model: CustomerFile

    url: "/customer_file"

    expandedFile: () ->
      @at(@expandedPosition)

    login: (customerFileUser) ->
      customerFileUser.loginTo(@expandedFile())

)
