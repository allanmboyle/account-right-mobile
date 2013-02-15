describe("LiveLoginView", () ->

  class StubEvent
    preventDefault: () ->

  LiveLoginView = null
  LiveUser = null

  specRequire(this, [ "jquerymobile",
                      "app/views/live_login",
                      "app/models/live_user" ], (jqm, LoadedLiveLoginView, LoadedLiveUser) ->
    LiveLoginView = LoadedLiveLoginView
    LiveUser = LoadedLiveUser
  )

  describe("when loaded", () ->

    it("should add a page placeholder to the dom", () ->
      expect($("#live_login")).toExist()
    )

  )

  describe("when instantiated", () ->

    liveLoginView = null

    beforeEach(() ->
      liveLoginView = new LiveLoginView()
    )

    afterEach(() ->
      $("#live_login").html("")
    )

    describe("and rendered", () ->

      beforeEach(() ->
        liveLoginView.render()
      )

      describe("and crendentials have been entered", () ->

        beforeEach(() ->
          $("#live_username").val("some username")
          $("#live_password").val("some password")
        )

        describe("#user", () ->

          it("should create a LiveUser whose username and password are taken from form fields", () ->
            liveUser = liveLoginView.user()

            expect(liveUser.get("username")).toEqual("some username")
            expect(liveUser.get("password")).toEqual("some password")
          )

        )

        describe("#login", () ->

          event = null
          liveUser = null

          beforeEach(() ->
            event = new StubEvent()
            liveUser = new LiveUser(username: "aUsername", password: "aPassword")
          )

          it("should navigate the user to the customer files page when the login attempt is successful", () ->
            spyOn(liveLoginView, "user").andReturn(liveUser)
            spyOn(liveUser, "login").andReturn(accessToken: "123", refreshToken: "456")

            liveLoginView.login(event)

            expect(location.hash).toBe("#customer_files")
          )

        )

      )

    )

  )

)
