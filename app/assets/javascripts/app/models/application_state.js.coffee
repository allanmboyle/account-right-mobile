define([ "./live_user", "./customer_file" ], (LiveUser, CustomerFile) ->

  class ApplicationState

    constructor: () ->
      @liveUser = new LiveUser()
      @openedCustomerFile = new CustomerFile(window.openedCustomerFile)

    isLoggedInToLive: () ->
      @liveUser.isLoggedIn

    isLoggedInToCustomerFile: () ->
      !@openedCustomerFile.isEmpty()

)
