describe("LiveUser", () ->

  Backbone = null
  liveUser = null

  jasmineRequire(this, [ "backbone", "app/models/live_user" ], (LoadedBackbone, LiveUser) ->
    Backbone = LoadedBackbone
    liveUser = new LiveUser(username: "someUsername", password: "somePassword")
  )

  describe("#login", () ->

    it("should contact the server in order to login", () ->
      spyOn(Backbone, "ajax")

      liveUser.login()

      console.log("Backbone.ajax.mostRecentCall: " + JSON.stringify(Backbone.ajax.mostRecentCall))
      requestType = Backbone.ajax.mostRecentCall.args[0]["type"]
      requestUrl = Backbone.ajax.mostRecentCall.args[0]["url"]
      requestData = Backbone.ajax.mostRecentCall.args[0]["data"]
      expect(requestType).toEqual("POST")
      expect(requestUrl).toEqual("/live_login")
      expect(requestData["username"]).toEqual("someUsername")
      expect(requestData["password"]).toEqual("somePassword")
    )

    describe("when the login is successful", () ->

      response = null

      beforeEach(() ->
        response = { accessToken: "123", refreshToken: "456" }
        spyOn(Backbone, "ajax").andCallFake((options) -> options.success(response))
      )

      it("should trigger a login:success event containing the servers response", () ->
        spyOn(liveUser, "trigger")

        liveUser.login()

        expect(liveUser.trigger).toHaveBeenCalledWith("login:success", response)
      )

    )

    describe("when the login is unsuccessful", () ->

      beforeEach(() ->
        spyOn(Backbone, "ajax").andCallFake((options) -> options.error())
      )

      it("should trigger a login:fail event", () ->
        spyOn(liveUser, "trigger")

        liveUser.login()

        expect(liveUser.trigger).toHaveBeenCalledWith("login:fail")
      )

    )

  )

)
