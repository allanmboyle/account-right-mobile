describe("ContactsDetailsView", () ->

  ContactDetailsView = null
  Contact = null
  customerFile = null
  applicationState = null

  jasmineRequire(this, [ "app/views/contact_details",
                         "app/models/contact",
                         "app/models/customer_file",
                         "app/models/application_state" ], (LoadedContactDetailsView, LoadedContact,
                                                            CustomerFile, ApplicationState) ->
    ContactDetailsView = LoadedContactDetailsView
    Contact = LoadedContact
    applicationState = new ApplicationState()
    customerFile = new CustomerFile(Name: "Some Customer File Name")
    applicationState.openedCustomerFile = customerFile
  )

  afterEach(() ->
    $("#contact-details").remove()
  )

  describe("when loaded", () ->

    it("should add a page placeholder to the dom", () ->
      expect($("#contact-details")).toExist()
    )

  )

  describe("when instantiated", () ->

    contactDetailsView = null

    beforeEach(() ->
      contactDetailsView = new ContactDetailsView(applicationState)
    )

    describe("#render", () ->

      describe("when an opened contact has been established in the application state", () ->

        beforeEach(() ->
          applicationState.openedContact = new Contact(
            CoLastName: "a Company", IsIndividual: false, FirstName: "",
            Type: "Customer", CurrentBalance: 100.00, Addresses: []
          )
        )

        it("should render a back button that redirects the user to the customer files page", () ->
           contactDetailsView.render()

           expect($("#contacts-back")).toHaveAttr("href", "#contacts")
        )

        describe("that has a comprehensive set of data", () ->

          beforeEach(() ->
            address = { Index: 1, Phone1: "111111111", Phone2: "222222222", Phone3: "333333333", Email: "someone@test.com", Street: "8 Some Place", City: "Somewhere", State: "VIC", PostCode: "3002", Country: "Australia" }
            applicationState.openedContact.set("Addresses", [ address ])
          )

          it("should render the opened customer file's name", () ->
            contactDetailsView.render()

            expect($(".customer-file-name")).toHaveText("Some Customer File Name")
          )

          it("should render the details of the contact", () ->
            contactDetailsView.render()

            expect($(".contact .name")).toHaveText("a Company")
            expect($(".contact .type")).toHaveText("Customer")
            expect($(".contact .balance")).toHaveText("They owe 100.00")
            renderedPhoneNumbers = _.map($(".contact .phoneNumber"), (element) -> $(element).text())
            expect(renderedPhoneNumbers).toEqual([ "111111111", "222222222", "333333333" ])
            expect($(".contact .emailAddress")).toHaveText("someone@test.com")
            renderedAddressLines = _.map($(".contact .address .line"), (element) -> $(element).text())
            expect(renderedAddressLines).toEqual(["8 Some Place", "Somewhere", "VIC 3002 Australia"])
          )

        )

        describe("that has address data whose values are empty", () ->

          beforeEach(() ->
            address = { Index: 1, Phone1: "", Phone2: "", Phone3: "", Email: "", Street: "", City: "", State: "", PostCode: "", Country: "" }
            applicationState.openedContact.set("Addresses", [ address ])
          )

          it("should not render any address details", () ->
            contactDetailsView.render()

            expect($(".contact .phoneNumber")).not.toExist()
            expect($(".contact .emailAddress")).not.toExist()
            expect($(".contact .address")).not.toExist()
          )

        )

        describe("that has no address data", () ->

          it("should not render any address details", () ->
            contactDetailsView.render()

            expect($(".contact .phoneNumber")).not.toExist()
            expect($(".contact .emailAddress")).not.toExist()
            expect($(".contact .address")).not.toExist()
          )

        )

      )

    )

  )

)
