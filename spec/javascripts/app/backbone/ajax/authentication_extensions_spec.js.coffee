describe("AuthenticationExtensions", () ->

  applicationState = null
  authenticationExtensions = null

  jasmineRequire(this, [ "app/models/application_state",
                         "app/backbone/ajax/authentication_extensions" ], (ApplicationState,
                                                                           AuthenticationExtensions) ->
    applicationState = new ApplicationState()
    authenticationExtensions = new AuthenticationExtensions(applicationState)
  )

  describe("#extendOptions", () ->

    originalLocationHash = "#some_location"

    beforeEach(() ->
      location.hash = originalLocationHash
    )

    describe("when the error callback is invoked in the extended options", () ->

      responseStatus = null
      responseText = null

      describe("and the error is caused by an authentication failure", () ->

        describe("because the user must be logged-in to AccountRight Live to perform the action", () ->

          beforeEach(() ->
            responseStatus = 401
            responseText = JSON.stringify(loginRequired: "live_login")
          )

          it("should inform the application state that a re-login is required", () ->
            extendOptionsAndInvokeErrorCallback({})

            expect(applicationState.reLoginRequired).toBeTruthy()
          )

          it("should redirect the user to the Live login page", () ->
            extendOptionsAndInvokeErrorCallback({})

            expect(location.hash).toBe("#live_login")
          )

          describe("and an error callback has been provided", () ->

            errorCallback = null

            beforeEach(() ->
              errorCallback = jasmine.createSpy()
            )

            it("should not invoke the callback", () ->
              extendOptionsAndInvokeErrorCallback(error: errorCallback)

              expect(errorCallback).not.toHaveBeenCalled()
            )

          )

        )

        describe("because the user failed an authentication request", () ->

          beforeEach(() ->
            responseStatus = 401
            responseText = ""
          )

          it("should not inform the application state that a re-login is required", () ->
            extendOptionsAndInvokeErrorCallback({})

            expect(applicationState.reLoginRequired).toBeFalsy()
          )

          it("should leave the user on the current page", () ->
            extendOptionsAndInvokeErrorCallback({})

            expect(location.hash).toBe(originalLocationHash)
          )

          describe("and an error callback has been provided", () ->

            errorCallback = null

            beforeEach(() ->
              errorCallback = jasmine.createSpy()
            )

            it("should invoke the callback with unaltered arguments", () ->
              extendOptionsAndInvokeErrorCallback(error: errorCallback)

              expect(errorCallback).toHaveBeenCalledWith({ status: 401 }, "some status", "some error description")
            )

          )

        )

      )

      describe("and the error has some other cause", () ->

        beforeEach(() ->
          responseStatus = 500
          responseText = "Some error response text"
        )

        it("should not inform the application state that a re-login is required", () ->
          extendOptionsAndInvokeErrorCallback({})

          expect(applicationState.reLoginRequired).toBeFalsy()
        )

        it("should leave the user on the current page", () ->
          extendOptionsAndInvokeErrorCallback({})

          expect(location.hash).toBe(originalLocationHash)
        )

        describe("and an error callback has been provided", () ->

          errorCallback = null

          beforeEach(() ->
            errorCallback = jasmine.createSpy()
          )

          it("should invoke the callback with unaltered arguments", () ->
            extendOptionsAndInvokeErrorCallback(error: errorCallback)

            expect(errorCallback).toHaveBeenCalledWith(
              { status: 500, responseText: "Some error response text" }, "some status", "some error description"
            )
          )

        )

      )

      extendOptionsAndInvokeErrorCallback = (options) ->
        actualOptions = authenticationExtensions.extendOptions(options)
        xhr = { status: responseStatus }
        xhr["responseText"] = responseText if responseText
        actualOptions.error(xhr, "some status", "some error description")

    )

  )

)
