describe("LiveUser", () ->

  LiveUser = null
  liveUser = null
  Backbone = null

  jasmineRequire(this, [ "app/models/live_user", "backbone" ], (LoadedLiveUser, LoadedBackbone) ->
    LiveUser = LoadedLiveUser
    liveUser = new LiveUser(username: "someUsername", password: "somePassword")
    Backbone = LoadedBackbone
  )

  describe("constructor", () ->

   describe("when the window contains a flag indicating the user is logged-in to AccountRight Live", () ->

      beforeEach(() ->
        window.isLoggedInToLive = true

        liveUser = new LiveUser()
      )

      afterEach(() ->
        window.isLoggedInToLive = null
      )

      it("should mark the user as logged-in", () ->
        expect(liveUser.isLoggedIn).toBeTruthy()
      )

    )

  )

  describe("#reset", () ->

    it("should contact the server in order to reset the current users session", () ->
      spyOn(Backbone, "ajax")

      liveUser.reset()

      ajaxOptions = Backbone.ajax.mostRecentCall.args[0]
      expect(ajaxOptions["type"]).toEqual("GET")
      expect(ajaxOptions["url"]).toEqual("/live_user/reset")
    )

    describe("when the reset request is successful", () ->

      beforeEach(() ->
        spyOn(Backbone, "ajax").andCallFake((options) -> options.success())
      )

      it("should trigger a reset:success event", () ->
        spyOn(liveUser, "trigger")

        liveUser.reset()

        expect(liveUser.trigger).toHaveBeenCalledWith("reset:success")
      )

      it("should mark the user as not logged-in", () ->
        liveUser.isLoggedIn = true

        liveUser.reset()

        expect(liveUser.isLoggedIn).toBeFalsy()
      )

    )

    describe("when the reset request fails", () ->

      beforeEach(() ->
        spyOn(Backbone, "ajax").andCallFake((options) -> options.error(status: 500))
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
      spyOn(Backbone, "ajax")

      liveUser.login()

      ajaxOptions = Backbone.ajax.mostRecentCall.args[0]
      expect(ajaxOptions["type"]).toEqual("POST")
      expect(ajaxOptions["url"]).toEqual("/live_user/login")
      requestData = ajaxOptions["data"]
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

      it("should mark the user as logged-in", () ->
        liveUser.isLoggedIn = false

        liveUser.login()

        expect(liveUser.isLoggedIn).toBeTruthy()
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
