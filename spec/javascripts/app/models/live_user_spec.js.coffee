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

      requestType = Backbone.ajax.mostRecentCall.args[0]["type"]
      requestUrl = Backbone.ajax.mostRecentCall.args[0]["url"]
      requestData = Backbone.ajax.mostRecentCall.args[0]["data"]
      expect(requestType).toEqual("POST")
      expect(requestUrl).toEqual("/live_login")
      expect(requestData["username"]).toEqual("someUsername")
      expect(requestData["password"]).toEqual("somePassword")
    )

    describe("when the login is successful", () ->

      beforeEach(() ->
        spyOn(Backbone, "ajax").andCallFake((options) -> options.success())
      )

      it("should trigger a login:success event", () ->
        spyOn(liveUser, "trigger")

        liveUser.login()

        expect(liveUser.trigger).toHaveBeenCalledWith("login:success")
      )

    )

    describe("when the login fails due to invalid credentials", () ->

      beforeEach(() ->
        spyOn(Backbone, "ajax").andCallFake((options) -> options.error(status: 401))
      )

      it("should trigger a login:fail event", () ->
        spyOn(liveUser, "trigger")

        liveUser.login()

        expect(liveUser.trigger).toHaveBeenCalledWith("login:fail")
      )

    )

    describe("when the login fails due to an arbitrary error", () ->

      beforeEach(() ->
        spyOn(Backbone, "ajax").andCallFake((options) -> options.error(status: 500))
      )

      it("should trigger a login:error event", () ->
        spyOn(liveUser, "trigger")

        liveUser.login()

        expect(liveUser.trigger).toHaveBeenCalledWith("login:error")
      )

    )

  )

)
