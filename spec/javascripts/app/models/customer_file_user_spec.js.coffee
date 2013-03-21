describe("customerFileUser", () ->

  Backbone = null
  customerFile = null
  customerFileUser = null

  jasmineRequire(this, [ "backbone", 
                         "app/models/customer_file", 
                         "app/models/customer_file_user" ], (LoadedBackbone, CustomerFile, CustomerFileUser) ->
    Backbone = LoadedBackbone
    customerFile = new CustomerFile(Id: "0123456789", Name: "Some File Name")
    customerFileUser = new CustomerFileUser(username: "someUsername", password: "somePassword")
  )

  describe("#loginTo", () ->

    it("should contact the server in order to login to the customer file", () ->
      spyOn(Backbone, "ajax")

      customerFileUser.loginTo(customerFile)

      requestType = Backbone.ajax.mostRecentCall.args[0]["type"]
      requestUrl = Backbone.ajax.mostRecentCall.args[0]["url"]
      requestData = Backbone.ajax.mostRecentCall.args[0]["data"]
      expect(requestType).toEqual("POST")
      expect(requestUrl).toEqual("/customer_file_login")
      expect(requestData["fileId"]).toEqual("0123456789")
      expect(requestData["username"]).toEqual("someUsername")
      expect(requestData["password"]).toEqual("somePassword")
    )

    describe("when the login is successful", () ->

      beforeEach(() ->
        spyOn(Backbone, "ajax").andCallFake((options) -> options.success())
      )

      it("should trigger a login:success event", () ->
        spyOn(customerFileUser, "trigger")

        customerFileUser.loginTo(customerFile)

        expect(customerFileUser.trigger).toHaveBeenCalledWith("login:success")
      )

    )

    describe("when the login is unsuccessful", () ->

      beforeEach(() ->
        spyOn(Backbone, "ajax").andCallFake((options) -> options.error(status: 400))
      )

      it("should trigger a login:fail event", () ->
        spyOn(customerFileUser, "trigger")

        customerFileUser.loginTo(customerFile)

        expect(customerFileUser.trigger).toHaveBeenCalledWith("login:fail")
      )

    )

    describe("when the login fails due to the the login service being unavailable", () ->

      beforeEach(() ->
        spyOn(Backbone, "ajax").andCallFake((options) -> options.error(status: 500))
      )

      it("should trigger a login:error event", () ->
        spyOn(customerFileUser, "trigger")

        customerFileUser.loginTo(customerFile)

        expect(customerFileUser.trigger).toHaveBeenCalledWith("login:error")
      )

    )

  )

)
