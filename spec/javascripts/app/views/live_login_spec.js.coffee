describe("LiveLoginView", () ->

  class StubEvent
    preventDefault: () ->

  _ = null
  LiveLoginView = null
  LiveUser = null

  jasmineRequire(this, [ "underscore",
                         "app/views/live_login",
                         "app/models/live_user" ], (Underscore, LoadedLiveLoginView, LoadedLiveUser) ->
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
      failSpy = null
      errorSpy = null

      beforeEach(() ->
        initialActions["success"] = LiveLoginView.prototype.success
        initialActions["fail"] = LiveLoginView.prototype.fail
        initialActions["error"] = LiveLoginView.prototype.error
        successSpy = LiveLoginView.prototype.success = jasmine.createSpy()
        failSpy = LiveLoginView.prototype.fail = jasmine.createSpy()
        errorSpy = LiveLoginView.prototype.error = jasmine.createSpy()

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

      it("should cause the fail action to be invoked when the users login:fail event occurs", () ->
        liveUser.trigger("login:fail")

        expect(failSpy).toHaveBeenCalled()
      )

      it("should cause the error action to be invoked when the users login:error event occurs", () ->
        liveUser.trigger("login:error")

        expect(errorSpy).toHaveBeenCalled()
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

        describe("#fail", () ->

          beforeEach(() ->
            location.hash = "#live_login"
          )

          it("should leave the user on the customer files page", () ->
            liveLoginView.fail()

            expect(location.hash).toMatch(/^#live_login/)
          )

          it("should make the login failure popup visible", () ->
            liveLoginView.fail()

            expect($("#live_login_fail_message-popup")).toHaveClass("ui-popup-active")
          )

          it("should display a popup with a message indicating the login attempt failed", () ->
             liveLoginView.fail()

             expect($("#live_login_fail_message")).toHaveText("The username or password you entered is incorrect")
          )

        )

        describe("#error", () ->

          beforeEach(() ->
            location.hash = "#live_login"
          )

          it("should leave the user on the customer files page", () ->
            liveLoginView.error()

            expect(location.hash).toMatch(/^#live_login/)
          )

          it("should make the login error popup visible", () ->
            liveLoginView.error()

            expect($("#live_login_error_message-popup")).toHaveClass("ui-popup-active")
          )

          it("should display a popup with a message indicating an error occurred during the login attempt", () ->
             liveLoginView.error()

             expect($("#live_login_error_message")).toHaveText("We can't confirm your details at the moment, try again shortly")
          )

        )

      )

    )

  )

)
