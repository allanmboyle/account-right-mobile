describe("ContactsView", () ->

  Backbone = null
  ContactsView = null
  RequireLiveLoginFilter = null
  Contact = null
  customerFile = null
  applicationState = null

  jasmineRequire(this, [ "backbone",
                         "app/views/contacts",
                         "app/views/filters/require_live_login",
                         "app/models/contact",
                         "app/models/customer_file",
                         "app/models/application_state" ], (LoadedBackbone, LoadedContactsView,
                                                            LoadedRequireLiveLoginFilter, LoadedContact,
                                                            CustomerFile, ApplicationState) ->
    Backbone = LoadedBackbone
    ContactsView = LoadedContactsView
    RequireLiveLoginFilter = LoadedRequireLiveLoginFilter
    Contact = LoadedContact
    customerFile = new CustomerFile(Name: "Some File Name")
    applicationState = new ApplicationState()
    applicationState.openedCustomerFile = customerFile
    spyOn(applicationState, "isLoggedInToLive").andReturn(true)
  )

  beforeEach(() ->
    # Compensation for pageshow not being triggered in behaviours
    $("#contacts").on("pagebeforeshow", () -> $("#contacts").trigger("pageshow"))
  )

  afterEach(() ->
    $("#contacts").remove()
  )

  describe("when loaded", () ->

    it("should add a page placeholder to the dom", () ->
      expect($("#contacts")).toExist()
    )

  )

  describe("when instantiated", () ->

    initialPrototype = null
    contactsView = null

    beforeEach(() ->
      initialPrototype = _.extend({}, ContactsView.prototype)
      establishView()
    )

    afterEach(() ->
      ContactsView.prototype = initialPrototype
    )

    it("should require the user to be logged-in to AccountRight Live", () ->
      expect(new ContactsView(applicationState).filters[0] instanceof RequireLiveLoginFilter).toBeTruthy()
    )

    describe("#update", () ->

      describe("when contacts are successfully fetched", () ->

        beforeEach(() ->
          response = [{ CoLastName: "A Company", IsIndividual: false, FirstName: "", Type: "Customer", CurrentBalance: 100.00 },
                      { CoLastName: "Noah", IsIndividual: true, FirstName: "Joachim", Type: "Supplier", CurrentBalance: -100.00 },
                      { CoLastName: "Another Company", IsIndividual: false, FirstName: "", Type: "Customer", CurrentBalance: 200.00 }]
          spyOn(Backbone, "ajax").andCallFake((options) -> options.success(response))
        )

        it("should render the view", () ->
          renderSpy = ContactsView.prototype.render = jasmine.createSpy()
          establishView()

          contactsView.update()

          renderToBeCalled = () -> renderSpy.callCount == 1
          waitsFor(renderToBeCalled, "update action to eventually trigger render", 5000)
        )

        it("should render the opened customer file's name", () ->
          contactsView.update()

          expect($(".customer-file-name")).toHaveText("Some File Name")
        )

        it("should render an overview of the contacts", () ->
           contactsView.update()

           contacts = $(".contact")
           assertContact(contacts[0], { name: "A Company", type: "Customer", balance: "100.00" })
           assertContact(contacts[1], { name: "Another Company", type: "Customer", balance: "200.00" })
           assertContact(contacts[2], { name: "Noah, Joachim", type: "Supplier", balance: "100.00" })
        )

        it("should not show a message indicating an error occurred", () ->
          contactsView.update()

          expect($("#contacts-general-error-message-popup")).not.toHaveClass("ui-popup-active")
        )

      )

      describe("when an error occurs fetching the contacts", () ->

        beforeEach(() ->
          spyOn(Backbone, "ajax").andCallFake((options) -> options.error())
        )

        it("should render the view", () ->
          renderSpy = ContactsView.prototype.render = jasmine.createSpy()
          establishView()

          contactsView.update()

          renderToBeCalled = () -> renderSpy.callCount == 1
          waitsFor(renderToBeCalled, "update action to eventually trigger render", 5000)
        )

        it("should show a message indicating an error occurred", () ->
          contactsView.update()

          generalErrorMessageToBeVisible = () -> $("#contacts-general-error-message-popup").hasClass("ui-popup-active")
          waitsFor(generalErrorMessageToBeVisible, "general error message to be visible", 5000)
        )

      )

    )

    describe("#render", () ->

      it("should render a back button that redirects the user to the customer files page", () ->
        contactsView.render()

        expect($("#customer-file-logout")).toHaveAttr("href", "#customer_files")
      )

      describe("when contacts have been added", () ->

        contacts = null

        beforeEach(() ->
          contactsView.contacts.add([new Contact(CoLastName: "a Company", IsIndividual: false, FirstName: "", Type: "Customer", CurrentBalance: -100.00),
                                     new Contact(CoLastName: "Another Company", IsIndividual: false, FirstName: "", Type: "Supplier", CurrentBalance: 200.00)])
          contacts = contactsView.contacts
        )

        it("should group contacts by their case-insensitive CoLastName", () ->
          contactsView.render()

          groupLetters = $(".ui-li-divider").text()
          expect(groupLetters).toBe("A")
          contactElements = $(".contact")
          assertContact(contactElements[0], { name: "a Company", type: "Customer", balance: "100.00" })
          assertContact(contactElements[1], { name: "Another Company", type: "Supplier", balance: "200.00" })
        )

        it("should render the balance as the contacts balance description", () ->
          spyOn(contacts.at(0), "balanceDescription").andReturn("first description")
          spyOn(contacts.at(1), "balanceDescription").andReturn("second description")
          contactsView.render()

          contactElements = $(".contact")
          expect($(contactElements[0]).find(".balance")).toHaveText("first description")
          expect($(contactElements[1]).find(".balance")).toHaveText("second description")
        )

        it("should render the balance in an element that has a class indicating the contacts balance", () ->
          spyOn(contacts.at(0), "balanceClass").andReturn("firstClass")
          spyOn(contacts.at(1), "balanceClass").andReturn("secondClass")
          contactsView.render()

          contactElements = $(".contact")
          expect($(contactElements[0]).find(".balance")).toHaveClass("firstClass")
          expect($(contactElements[1]).find(".balance")).toHaveClass("secondClass")
        )

        it("should not show a message indicating no contacts are available", () ->
           contactsView.render()

           noContactsAvailableMessageToBeHidden = () -> $("#no-contacts-message").is(":hidden")
           waitsFor(noContactsAvailableMessageToBeHidden, "No contacts available message to be hidden", 5000)
        )

        describe("and the user clicks a contact", () ->

          beforeEach(() ->
            contactsView.render()
          )

          it("should invoke the open action", () ->
            spyOn(contactsView, "open")
            contactsView.delegateEvents() # Attach spy to DOM events

            $($(".contact")[1]).click()

            openActionToBeInvoked = () -> contactsView.open.callCount == 1
            waitsFor(openActionToBeInvoked, "contact click to invoke open action", 5000)
          )

        )

      )

      describe("when no contacts are retrived", () ->

        it("should show a message indicating no contacts are available", () ->
          contactsView.render()

          noContactsAvailableMessageToBeVisible = () -> $("#no-contacts-message").is(":visible")
          waitsFor(noContactsAvailableMessageToBeVisible, "No contacts available message to be visible", 5000)
        )

      )

    )

    describe("#open", () ->

      describe("when the view has been rendered with multiple contacts", () ->

        contacts = null
        event = null

        beforeEach(() ->
          contacts = [new Contact(CoLastName: "a Company", IsIndividual: false, FirstName: "", Type: "Customer", CurrentBalance: 100.00),
                      new Contact(CoLastName: "Another Company", IsIndividual: false, FirstName: "", Type: "Supplier", CurrentBalance: 200.00)]
          contactsView.contacts.add(contacts)
          contactsView.render()
        )

        describe("and the event target is a contact element", () ->

          beforeEach(() ->
            event = new StubEvent()
            event.target = $(".contact")[1]
          )

          it("should establish the associated contact object in the application state", () ->
            contactsView.open(event)

            openedContactToBeInApplicationState = () -> applicationState.openedContact == contacts[1]
            waitsFor(openedContactToBeInApplicationState,
                     "clicked contact to be established in the application state", 5000)
          )

          it("should navigate the user to the contact details page", () ->
            contactsView.open(event)

            navigationToTheContactDetailsPage = () -> location.hash == "#contact_details"
            waitsFor(navigationToTheContactDetailsPage,
                     "contact click navigating the user to the contact details page", 5000)
          )

        )

        describe("and the event target is an element within a contact", () ->

          beforeEach(() ->
            event = new StubEvent()
            event.target = $(".contact .name")[0]
          )

          it("should establish the associated contact object in the application state", () ->
            contactsView.open(event)

            openedContactToBeInApplicationState = () -> applicationState.openedContact == contacts[0]
            waitsFor(openedContactToBeInApplicationState,
                     "clicked contact to be established in the application state", 5000)
          )

        )

      )

    )

    establishView = () ->
      contactsView = new ContactsView(applicationState)
      contactsView.filters = []

    assertContact = (container, expectedValues) ->
      jqueryContainer = $(container)
      expect(jqueryContainer.find(".name")).toHaveText(expectedValues.name)
      expect(jqueryContainer.find(".type")).toHaveText(expectedValues.type)
      expect(jqueryContainer.find(".balance")).toHaveText(new RegExp(regexEscape(expectedValues.balance)))

  )

)
