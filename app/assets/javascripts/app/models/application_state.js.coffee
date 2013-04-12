define([ "./customer_file" ], (CustomerFile) ->

  class ApplicationState

    constructor: () ->
      @openedCustomerFile = new CustomerFile(window.openedCustomerFile)

)
