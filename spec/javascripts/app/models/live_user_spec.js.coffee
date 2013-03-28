describe("LiveUser", () ->

  Ajax = null
  liveUser = null

  jasmineRequire(this, [ "app/models/ajax", "app/models/live_user" ], (LoadedAjax, LiveUser) ->
    Ajax = LoadedAjax
    liveUser = new LiveUser(username: "someUsername", password: "somePassword")
  )

  describe("#reset", () ->

    it("should contact the server in order to reset the current users session", () ->
      spyOn(Ajax, "submit")

      liveUser.reset()

      ajaxOptions = Ajax.submit.mostRecentCall.args[0]
      expect(ajaxOptions["type"]).toEqual("GET")
      expect(ajaxOptions["url"]).toEqual("/live_user/reset")
    )

    describe("when the reset request is successful", () ->

      beforeEach(() ->
        spyOn(Ajax, "submit").andCallFake((options) -> options.success())
      )

      it("should trigger a reset:success event", () ->
        spyOn(liveUser, "trigger")

        liveUser.reset()

        expect(liveUser.trigger).toHaveBeenCalledWith("reset:success")
      )

    )

    describe("when the reset request fails", () ->

      beforeEach(() ->
        spyOn(Ajax, "submit").andCallFake((options) -> options.error(status: 500))
      )

      it("should trigger a reset:error event", () ->
        spyOn(liveUser, "trigger")

        liveUser.reset()

        expect(liveUser.trigger).toHaveBeenCalledWith("reset:error")
      )

    )

  )

  describe("#login", () ->

    it("should contact the server in order to login", () ->
      spyOn(Ajax, "submit")

      liveUser.login()

      ajaxOptions = Ajax.submit.mostRecentCall.args[0]
      expect(ajaxOptions["type"]).toEqual("POST")
      expect(ajaxOptions["url"]).toEqual("/live_user/login")
      requestData = ajaxOptions["data"]
      expect(requestData["username"]).toEqual("someUsername")
      expect(requestData["password"]).toEqual("somePassword")
    )

    describe("when the login is successful", () ->

      beforeEach(() ->
        spyOn(Ajax, "submit").andCallFake((options) -> options.success())
      )

      it("should trigger a login:success event", () ->
        spyOn(liveUser, "trigger")

        liveUser.login()

        expect(liveUser.trigger).toHaveBeenCalledWith("login:success")
      )

    )

    describe("when the login fails due to invalid credentials", () ->

      beforeEach(() ->
        spyOn(Ajax, "submit").andCallFake((options) -> options.error(status: 401))
      )

      it("should trigger a login:fail event", () ->
        spyOn(liveUser, "trigger")

        liveUser.login()

        expect(liveUser.trigger).toHaveBeenCalledWith("login:fail")
      )

    )

    describe("when the login fails due to an arbitrary error", () ->

      beforeEach(() ->
        spyOn(Ajax, "submit").andCallFake((options) -> options.error(status: 500))
      )

      it("should trigger a login:error event", () ->
        spyOn(liveUser, "trigger")

        liveUser.login()

        expect(liveUser.trigger).toHaveBeenCalledWith("login:error")
      )

    )

  )

)
