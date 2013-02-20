describe("LiveLoginView", () ->

  class StubEvent
    preventDefault: () ->

  _ = null
  LiveLoginView = null
  LiveUser = null

  jasmineRequire(this, [ "jquerymobile",
                         "underscore",
                         "app/views/live_login",
                         "app/models/live_user" ], (jqm, Underscore, LoadedLiveLoginView, LoadedLiveUser) ->
    _ = Underscore
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
    liveUser = null

    beforeEach(() ->
      liveLoginView = new LiveLoginView()
      liveUser = liveLoginView.user
    )

    afterEach(() ->
      $("#live_login").html("")
    )

    describe("model event configuration", () ->

      initialActions = {}
      successSpy = null

      beforeEach(() ->
        initialActions["success"] = LiveLoginView.prototype.success
        successSpy = LiveLoginView.prototype.success = jasmine.createSpy()

        liveLoginView = new LiveLoginView()
        liveUser = liveLoginView.user
      )

      afterEach(() ->
        _.extend(LiveLoginView.prototype, initialActions)
      )

      it("should cause the success action to be invoked when the users login:success event occurs", () ->
        response = { key: "value" }
        liveUser.trigger("login:success", response)

        expect(successSpy).toHaveBeenCalledWith(response)
      )

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

        describe("#syncUser", () ->

          it("should update the users username and password with form field values", () ->
            liveLoginView.syncUser()

            expect(liveUser.get("username")).toEqual("some username")
            expect(liveUser.get("password")).toEqual("some password")
          )

        )

        describe("#login", () ->

          event = null

          beforeEach(() ->
            event = new StubEvent()
            
            spyOn(liveLoginView, "syncUser")
            spyOn(liveUser, "login")
          )

          it("should update the user to include the entered credentials", () ->
            liveLoginView.login(event)
            
            expect(liveLoginView.syncUser).toHaveBeenCalled()
          )
          
          it("should login the user via the model", () ->
            liveLoginView.login(event)

            expect(liveUser.login).toHaveBeenCalled()
          )

        )
        
        describe("#success", () ->

          beforeEach(() ->
            location.hash = ""
          )

          it("should navigate the user to the customer files page", () ->
            liveLoginView.success({})

            expect(location.hash).toBe("#customer_files")
          )
          
        )

      )

    )

  )

)
