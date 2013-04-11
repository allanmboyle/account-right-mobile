describe("LiveLoginView", () ->

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

  afterEach(() ->
    $("#live_login").remove()
  )

  describe("when loaded", () ->

    it("should add a page placeholder to the dom", () ->
      expect($("#live_login")).toExist()
    )

  )

  describe("when instantiated", () ->

    initialPrototype = null
    liveLoginView = null
    liveUser = null

    beforeEach(() ->
      initialPrototype = _.extend({}, LiveLoginView.prototype)
      liveLoginView = new LiveLoginView()
      liveUser = liveLoginView.user
    )

    afterEach(() ->
      LiveLoginView.prototype = initialPrototype
    )

    describe("model event configuration", () ->

      resetSuccessSpy = null
      resetErrorSpy = null
      loginSuccessSpy = null
      loginFailSpy = null
      loginErrorSpy = null

      beforeEach(() ->
        resetSuccessSpy = LiveLoginView.prototype.resetSuccess = jasmine.createSpy()
        resetErrorSpy = LiveLoginView.prototype.resetError = jasmine.createSpy()
        loginSuccessSpy = LiveLoginView.prototype.loginSuccess = jasmine.createSpy()
        loginFailSpy = LiveLoginView.prototype.loginFail = jasmine.createSpy()
        loginErrorSpy = LiveLoginView.prototype.loginError = jasmine.createSpy()

        liveLoginView = new LiveLoginView()
        liveUser = liveLoginView.user
      )

      it("should cause the resetSuccess action to be invoked when the users reset:success event occurs", () ->
        liveUser.trigger("reset:success")

        expect(resetSuccessSpy).toHaveBeenCalled()
      )

      it("should cause the resetError action to be invoked when the users reset:error event occurs", () ->
        liveUser.trigger("reset:error")

        expect(resetErrorSpy).toHaveBeenCalled()
      )

      it("should cause the loginSuccess action to be invoked when the users login:success event occurs", () ->
        liveUser.trigger("login:success")

        expect(loginSuccessSpy).toHaveBeenCalled()
      )

      it("should cause the loginFail action to be invoked when the users login:fail event occurs", () ->
        liveUser.trigger("login:fail")

        expect(loginFailSpy).toHaveBeenCalled()
      )

      it("should cause the loginError action to be invoked when the users login:error event occurs", () ->
        liveUser.trigger("login:error")

        expect(loginErrorSpy).toHaveBeenCalled()
      )

    )

    describe("#render", () ->

      it("should reset the current user", () ->
        spyOn(liveUser, "reset")

        liveLoginView.render()

        expect(liveUser.reset).toHaveBeenCalled()
      )

    )

    describe("and rendered", () ->

      beforeEach(() ->
        liveLoginView.resetSuccess()
      )

      describe("and crendentials have been entered", () ->

        beforeEach(() ->
          $("#live_email_address").val("some@email.address")
          $("#live_password").val("some password")
        )

        describe("#syncUser", () ->

          it("should update the users username and password with form field values", () ->
            liveLoginView.syncUser()

            expect(liveUser.get("emailAddress")).toEqual("some@email.address")
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

          it("should prevent propogation of the event", () ->
            spyOn(event, "preventDefault")

            liveLoginView.login(event)

            expect(event.preventDefault).toHaveBeenCalled()
          )

        )

        describe("#resetError", () ->

          beforeEach(() ->
            location.hash = "#live_login"
          )

          it("should leave the user on the live login page", () ->
            liveLoginView.resetError()

            expect(location.hash).toMatch(/^#live_login/)
          )

          it("should make the general error message popup visible", () ->
            liveLoginView.resetError()

            expect($("#live-login-general-error-message-popup")).toHaveClass("ui-popup-active")
          )

        )

        describe("#loginSuccess", () ->

          beforeEach(() ->
            location.hash = ""
          )

          it("should navigate the user to the customer files page", () ->
            liveLoginView.loginSuccess({})

            expect(location.hash).toBe("#customer_files")
          )
          
        )

        describe("#loginFail", () ->

          beforeEach(() ->
            location.hash = "#live_login"
          )

          it("should leave the user on the live login page", () ->
            liveLoginView.loginFail()

            expect(location.hash).toMatch(/^#live_login/)
          )

          it("should make the login failure popup visible", () ->
            liveLoginView.loginFail()

            expect($("#live-login-fail-message-popup")).toHaveClass("ui-popup-active")
          )

          it("should display a popup with a message indicating the login attempt failed", () ->
             liveLoginView.loginFail()

             expect($("#live-login-fail-message")).toHaveText("The username or password you entered is incorrect")
          )

        )

        describe("#loginError", () ->

          beforeEach(() ->
            location.hash = "#live_login"
          )

          it("should leave the user on the live login page", () ->
            liveLoginView.loginError()

            expect(location.hash).toMatch(/^#live_login/)
          )

          it("should make the login error popup visible", () ->
            liveLoginView.loginError()

            expect($("#live-login-error-message-popup")).toHaveClass("ui-popup-active")
          )

          it("should display a popup with a message indicating an error occurred during the login attempt", () ->
             liveLoginView.loginError()

             expect($("#live-login-error-message")).toHaveText("We can't confirm your details at the moment, try again shortly")
          )

        )

      )

    )

  )

)
