define([ "./customer_file" ], (CustomerFile) ->

  class ApplicationState

    constructor: () ->
      @isLoggedInToLive = window.isLoggedInToLive
      @openedCustomerFile = new CustomerFile(window.openedCustomerFile)

)
