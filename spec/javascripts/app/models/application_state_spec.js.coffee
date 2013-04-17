describe("ApplicationState", () ->

  ApplicationState = null
  CustomerFile = null
  applicationState = null
  liveUser = null

  jasmineRequire(this, [ "app/models/application_state",
                         "app/models/customer_file" ], (LoadedApplicationState, LoadedCustomerFile) ->
    ApplicationState = LoadedApplicationState
    CustomerFile = LoadedCustomerFile
  )

  describe("#openedCustomerFile", () ->

    describe("when the window contains an opened customer file hash", () ->

      afterEach(() ->
        window.openedCustomerFile = null
      )

      describe("that has values", () ->

        beforeEach(() ->
          customerFileHash = { Id: "some-customer-file-id", Name: "Some Customer File Name" }
          window.openedCustomerFile = customerFileHash

          establishApplicationState()
        )

        it("should return a CustomerFile whose values match those in the window hash", () ->
          customerFile = applicationState.openedCustomerFile

          expect(customerFile.get("Id")).toBe("some-customer-file-id")
          expect(customerFile.get("Name")).toBe("Some Customer File Name")
        )

      )

      describe("that is empty", () ->

        beforeEach(() ->
          window.openedCustomerFile = {}

          establishApplicationState()
        )

        it("should return a CustomerFile with default values", () ->
          customerFile = applicationState.openedCustomerFile

          expect(customerFile.get("Id")).toBe("Not specified")
          expect(customerFile.get("Name")).toBe("Not specified")
        )

      )

    )

  )

  describe("#isLoggedInToLive", () ->

    describe("when the user has logged-in to AccountRight Live", () ->

      beforeEach(() ->
        establishApplicationState()

        liveUser.isLoggedIn = true
      )

      it("should return true", () ->
        expect(applicationState.isLoggedInToLive()).toBeTruthy()
      )

    )

    describe("when the user has not logged-in to AccountRight Live", () ->

      beforeEach(() ->
        establishApplicationState()

        liveUser.isLoggedIn = false
      )

      it("should return false", () ->
        expect(applicationState.isLoggedInToLive()).toBeFalsy()
      )

    )

  )

  establishApplicationState = () ->
    applicationState = new ApplicationState()
    liveUser = applicationState.liveUser

)
