describe("ApplicationState", () ->

  ApplicationState = null
  CustomerFile = null

  jasmineRequire(this, [ "app/models/application_state",
                         "app/models/customer_file" ], (LoadedApplicationState, LoadedCustomerFile) ->
    ApplicationState = LoadedApplicationState
    CustomerFile = LoadedCustomerFile
  )

  describe("when instatiated", () ->

    applicationState = null

    describe("and the window contains an opened customer file hash", () ->

      customerFile = null

      beforeEach(() ->
        customerFileHash = { Id: "some-customer-file-id", Name: "Some Customer File Name" }
        window.openedCustomerFile = customerFileHash

        applicationState = new ApplicationState()
      )

      afterEach(() ->
        window.openedCustomerFile = null
      )

      it("should have an opened customer file whose values match those in the hash", () ->
        customerFile = applicationState.openedCustomerFile

        expect(customerFile.get("Id")).toBe("some-customer-file-id")
        expect(customerFile.get("Name")).toBe("Some Customer File Name")
      )

    )

  )

)
