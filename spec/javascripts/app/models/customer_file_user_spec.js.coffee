describe("customerFileUser", () ->

  Ajax = null
  customerFile = null
  customerFileUser = null

  jasmineRequire(this, [ "app/models/ajax",
                         "app/models/customer_file", 
                         "app/models/customer_file_user" ], (LoadedAjax, CustomerFile, CustomerFileUser) ->
    Ajax = LoadedAjax
    customerFile = new CustomerFile(Id: "0123456789", Name: "Some File Name")
    customerFileUser = new CustomerFileUser(username: "someUsername", password: "somePassword")
  )

  describe("#loginTo", () ->

    it("should contact the server in order to login to the customer file", () ->
      spyOn(Ajax, "submit")

      customerFileUser.loginTo(customerFile)

      ajaxOptions = Ajax.submit.mostRecentCall.args[0]
      expect(ajaxOptions["type"]).toEqual("POST")
      expect(ajaxOptions["url"]).toEqual("/customer_file/login")
      requestData = ajaxOptions["data"]
      expect(requestData["fileId"]).toEqual("0123456789")
      expect(requestData["username"]).toEqual("someUsername")
      expect(requestData["password"]).toEqual("somePassword")
    )

    describe("when the login is successful", () ->

      beforeEach(() ->
        spyOn(Ajax, "submit").andCallFake((options) -> options.success())
      )

      it("should trigger a login:success event", () ->
        spyOn(customerFileUser, "trigger")

        customerFileUser.loginTo(customerFile)

        expect(customerFileUser.trigger).toHaveBeenCalledWith("login:success")
      )

    )

    describe("when the login is fails due to invalid credentials", () ->

      beforeEach(() ->
        spyOn(Ajax, "submit").andCallFake((options) -> options.error(status: 401))
      )

      it("should trigger a login:fail event", () ->
        spyOn(customerFileUser, "trigger")

        customerFileUser.loginTo(customerFile)

        expect(customerFileUser.trigger).toHaveBeenCalledWith("login:fail")
      )

    )

    describe("when the login fails due to an arbitrary error", () ->

      beforeEach(() ->
        spyOn(Ajax, "submit").andCallFake((options) -> options.error(status: 500))
      )

      it("should trigger a login:error event", () ->
        spyOn(customerFileUser, "trigger")

        customerFileUser.loginTo(customerFile)

        expect(customerFileUser.trigger).toHaveBeenCalledWith("login:error")
      )

    )

  )

)
