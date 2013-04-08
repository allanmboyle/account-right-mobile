describe("ContactsView", () ->

  Backbone = null
  ContactsView = null
  Contact = null

  jasmineRequire(this, [ "backbone",
                         "app/views/contacts",
                         "app/models/contact" ], (LoadedBackbone, LoadedContactsView, LoadedContact) ->
    Backbone = LoadedBackbone
    ContactsView = LoadedContactsView
    Contact = LoadedContact
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

    contactsView = null

    beforeEach(() ->
      contactsView = new ContactsView()
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
          spyOn(contactsView, "render")

          contactsView.update()

          renderToBeCalled = () -> contactsView.render.callCount == 1
          waitsFor(renderToBeCalled, "update action to eventually trigger render", 5000)
        )

        it("should place the retrieved contacts in the dom", () ->
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
          spyOn(contactsView, "render")

          contactsView.update()

          renderToBeCalled = () -> contactsView.render.callCount == 1
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

      describe("when contacts have been added", () ->

        beforeEach(() ->
          contactsView.contacts.add([new Contact(CoLastName: "a Company", IsIndividual: false, FirstName: "", Type: "Customer", CurrentBalance: 100.00),
                                     new Contact(CoLastName: "Another Company", IsIndividual: false, FirstName: "", Type: "Supplier", CurrentBalance: 200.00)])
        )

        it("should group contacts by their case-insensitive CoLastName", () ->
          contactsView.render()

          group_letters = $(".ui-li-divider").text()
          expect(group_letters).toBe("A")
          contacts = $(".contact")
          assertContact(contacts[0], { name: "a Company", type: "Customer", balance: "100.00" })
          assertContact(contacts[1], { name: "Another Company", type: "Supplier", balance: "200.00" })
        )

        it("should not show a message indicating no contacts are available", () ->
           contactsView.render()

           noContactsAvailableMessageToBeHidden = () -> $("#no-contacts-message").is(":hidden")

           waitsFor(noContactsAvailableMessageToBeHidden, "No contacts available message to be hidden", 5000)
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

    assertContact = (container, expectedValues) ->
      jqueryContainer = $(container)
      expect(jqueryContainer.find(".name")).toHaveText(expectedValues.name)
      expect(jqueryContainer.find(".type")).toHaveText(expectedValues.type)
      expect(jqueryContainer.find(".balance")).toHaveText(new RegExp(regexEscape(expectedValues.balance)))

  )

)
