describe("RequireLiveLoginFilter", () ->

  view = null
  applicationState = null
  filter = null

  jasmineRequire(this, [ "app/views/filters/require_live_login",
                         "app/models/application_state" ], (RequireLiveLoginFilter, ApplicationState) ->
    view = {}
    applicationState = new ApplicationState()
    view.applicationState = applicationState
    filter = new RequireLiveLoginFilter()
  )

  describe("#filter", () ->

    describe("when the user is logged-in to AccountRight Live", () ->

      beforeEach(() ->
        spyOn(applicationState, "isLoggedInToLive").andReturn(true)
      )

      it("should return true indicating the view may be rendered", () ->
        expect(filter.filter(view)).toBeTruthy()
      )

    )

    describe("when the user is not logged-in to AccountRight Live", () ->

      beforeEach(() ->
        location.hash = ""
        spyOn(applicationState, "isLoggedInToLive").andReturn(false)
      )

      it("should redirect the user to the AccountRight Live login page", () ->
        filter.filter(view)

        expect(location.hash).toBe("#live_login")
      )

      it("should indicate that a re-login is required", () ->
        filter.filter(view)

        expect(applicationState.reLoginRequired).toBeTruthy()
      )

      it("should return false indicating the view must not be rendered", () ->
        expect(filter.filter(view)).toBeFalsy()
      )

    )

  )

)
