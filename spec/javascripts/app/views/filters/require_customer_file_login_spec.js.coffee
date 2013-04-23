describe("RequireCustomerFileLoginFilter", () ->

  view = null
  applicationState = null
  filter = null

  jasmineRequire(this, [ "app/views/filters/require_customer_file_login",
                         "app/models/application_state" ], (RequireCustomerFileLoginFilter, ApplicationState) ->
    view = {}
    applicationState = new ApplicationState()
    view.applicationState = applicationState
    filter = new RequireCustomerFileLoginFilter()
  )

  describe("#filter", () ->

    describe("when the user is logged-in to a Customer File", () ->

      beforeEach(() ->
        spyOn(applicationState, "isLoggedInToCustomerFile").andReturn(true)
      )

      it("should return true indicating the view may be rendered", () ->
        expect(filter.filter(view)).toBeTruthy()
      )

    )

    describe("when the user is not logged-in to a Customer File", () ->

      beforeEach(() ->
        location.hash = ""
        spyOn(applicationState, "isLoggedInToCustomerFile").andReturn(false)
      )

      it("should redirect the user to the Customer Files page", () ->
        filter.filter(view)

        expect(location.hash).toBe("#customer_files")
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
