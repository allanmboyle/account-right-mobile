describe("ContactsView", () ->

  Backbone = null
  _ = null
  ContactsView = null
  RequireLiveLoginFilter = null
  RequireCustomerFileLoginFilter = null
  Contact = null
  customerFile = null
  applicationState = null

  jasmineRequire(this, [ "backbone",
                         "underscore",
                         "app/views/contacts",
                         "app/views/filters/require_live_login",
                         "app/views/filters/require_customer_file_login",
                         "app/models/contact",
                         "app/models/customer_file",
                         "app/models/application_state" ], (LoadedBackbone, LoadedUnderscore, LoadedContactsView,
                                                            LoadedRequireLiveLoginFilter,
                                                            LoadedRequireCustomerFileLoginFilter,
                                                            LoadedContact, CustomerFile, ApplicationState) ->
    Backbone = LoadedBackbone
    _ = LoadedUnderscore
    ContactsView = LoadedContactsView
    RequireLiveLoginFilter = LoadedRequireLiveLoginFilter
    RequireCustomerFileLoginFilter = LoadedRequireCustomerFileLoginFilter
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
      expect(new ContactsView(applicationState).filters).toContainAnInstanceOf(RequireLiveLoginFilter)
    )

    it("should require the user to be logged-in to a Customer File", () ->
      expect(new ContactsView(applicationState).filters).toContainAnInstanceOf(RequireCustomerFileLoginFilter)
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

        it("should show the contact filters", () ->
          contactsView.render()

          allFilterFormsToBeVisible = () -> $("#contacts-content form:visible").length == 2
          waitsFor(allFilterFormsToBeVisible, "all filter forms to be visible", 5000)
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

        describe("and the user clicks a balance filter button", () ->

          ["all", "they-owe", "i-owe"].forEach((balanceFilterType) ->

            describe("which filters by '#{balanceFilterType}'", () ->

              beforeEach(() ->
                contactsView.render()
              )

              it("should invoke the filter action", () ->
                spyOn(contactsView, "filter")
                contactsView.delegateEvents() # Attach spy to DOM events

                $("#contacts-#{balanceFilterType}-filter").parent().find("label").click()

                filterActionToBeInvoked = () -> contactsView.filter.callCount == 1
                waitsFor(filterActionToBeInvoked, "filter action to be invoked", 5000)
              )

            )

          )

        )

      )

      describe("when no contacts are retrived", () ->

        it("should show a message indicating no contacts are available", () ->
          contactsView.render()

          noContactsAvailableMessageToBeVisible = () -> $("#no-contacts-message").is(":visible")
          waitsFor(noContactsAvailableMessageToBeVisible, "no contacts available message to be visible", 5000)
        )

        it("should hide the contact filters", () ->
          contactsView.render()

          allFilterFormsToBeHidden = () -> $("#contacts-content form:hidden").length == 2
          waitsFor(allFilterFormsToBeHidden, "all filter forms to be hidden", 5000)
        )

      )

    )

    describe("#filter", () ->

      describe("when there is a mix of owed and owing contacts", () ->

        beforeEach(() ->
          contactsView.contacts.add([ createContact(CoLastName: "Company A", CurrentBalance: 100.00),
                                      createContact(CoLastName: "Company B", CurrentBalance: -200.00),
                                      createContact(CoLastName: "Company C", CurrentBalance: 200.00),
                                      createContact(CoLastName: "Sole Trader A", CurrentBalance: -800.00),
                                      createContact(CoLastName: "Sole Trader B", CurrentBalance: 800.00) ])
          contactsView.render()
        )

        describe("and the user filters by contacts that owe", () ->

          beforeEach(() ->
            $("#contacts-they-owe-filter").prop("checked", true)
          )

          it("should show the contacts that owe", () ->
            contactsView.filter()

            contactsThatOweToBeVisible = () -> hasVisibleContactPositions(0, 2, 4)
            waitsFor(contactsThatOweToBeVisible, "contacts that owe to be visible", 5000)
          )

          it("should hide the contacts the user owe's", () ->
            contactsView.filter()

            contactsTheUserOwesToBeHidden = () -> hasHiddenContactPositions(1, 3)
            waitsFor(contactsTheUserOwesToBeHidden, "contacts the user owe's to be hidden", 5000)
          )

        )

        describe("and the user filters by contacts they owe", () ->

          beforeEach(() ->
            $("#contacts-i-owe-filter").prop("checked", true)
          )

          it("should show the contacts they owe", () ->
            contactsView.filter()

            contactsTheUserOwesToBeVisible = () -> hasVisibleContactPositions(1, 3)
            waitsFor(contactsTheUserOwesToBeVisible, "contacts the user owe's to be visible", 5000)
          )

          it("should hide the contacts that owe", () ->
            contactsView.filter()

            contactsThatOweToBeHidden = () -> hasHiddenContactPositions(0, 2, 4)
            waitsFor(contactsThatOweToBeHidden, "contacts that owe to be hidden", 5000)
          )

        )

        describe("and the user filters by a contact name", () ->

          describe("that exactly matches a contacts name", () ->

            beforeEach(() ->
              establishNameFilterValue("Company C")
            )

            it("should show the contact whose name matches", () ->
              contactsView.filter()

              contactWithMatchingNameToBeVisible = () -> hasVisibleContactPositions(2)
              waitsFor(contactWithMatchingNameToBeVisible, "contact with a matching name to be visible", 5000)
            )

            it("should hide all other contacts", () ->
              contactsView.filter()

              contactsWhoseNameDoesNotMatchToBeHidden = () -> hasHiddenContactPositions(0, 1, 3, 4)
              waitsFor(contactsWhoseNameDoesNotMatchToBeHidden, "contacts with non-matching name to be hidden", 5000)
            )

          )

          describe("that matches a contacts name with different casing", () ->

            beforeEach(() ->
              establishNameFilterValue("company b")
            )

            it("should show the contact whose name matches", () ->
               contactsView.filter()

               contactWithMatchingNameToBeVisible = () -> hasVisibleContactPositions(1)
               waitsFor(contactWithMatchingNameToBeVisible, "contact with a matching name to be visible", 5000)
            )

            it("should hide all other contacts", () ->
               contactsView.filter()

               contactsWhoseNameDoesNotMatchToBeHidden = () -> hasHiddenContactPositions(0, 2, 3, 4)
               waitsFor(contactsWhoseNameDoesNotMatchToBeHidden, "contacts with non-matching name to be hidden", 5000)
            )

          )

          describe("that matches multiple contact names", () ->

            beforeEach(() ->
              establishNameFilterValue("Company")
            )

            it("should show the contacts whose name matches", () ->
              contactsView.filter()

              contactsWithMatchingNameToBeVisible = () -> hasVisibleContactPositions(0, 1, 2)
              waitsFor(contactsWithMatchingNameToBeVisible, "contacts with a matching name to be visible", 5000)
            )

            it("should hide all other contacts", () ->
              contactsView.filter()

              contactsWhoseNameDoesNotMatchToBeHidden = () -> hasHiddenContactPositions(3, 4)
              waitsFor(contactsWhoseNameDoesNotMatchToBeHidden, "contacts with non-matching name to be hidden", 5000)
            )

          )

        )

        describe("and the user applies a filter reducing the number of contacts shown", () ->

          beforeEach(() ->
            $("#contacts-they-owe-filter").prop("checked", true)
          )

          describe("and then applies the other filter", () ->

            beforeEach(() ->
              establishNameFilterValue("Company")
            )

            it("should show the contacts matching both filters", () ->
              contactsView.filter()

              contactsMatchingTheFiltersToBeVisible = () -> hasVisibleContactPositions(0, 2)
              waitsFor(contactsMatchingTheFiltersToBeVisible, "contacts matching the filters to be visible", 5000)
            )

            it("should hide all other contacts", () ->
              contactsView.filter()

              contactsNotMatchTheFiltersToBeHidden = () -> hasHiddenContactPositions(1, 3, 4)
              waitsFor(contactsNotMatchTheFiltersToBeHidden, "non-matching contacts to be hidden", 5000)
            )

          )

          describe("and then removes the filter", () ->

            beforeEach(() ->
              $("#contacts-all-filter").prop("checked", true)
            )

            it("should show all the contacts", () ->
               contactsView.filter()

               allContactsToBeVisible = () -> hasVisibleContactPositions(0, 1, 2, 3, 4)
               waitsFor(allContactsToBeVisible, "all contacts to be visible", 5000)
            )

          )

        )

        describe("and the users filter results in no contacts being shown", () ->

          beforeEach(() ->
            establishNameFilterValue("someNonExistantContactName")
          )

          it("should hide all the contacts", () ->
            contactsView.filter()

            allContactsToBeHidden = () -> hasHiddenContactPositions(0, 1, 2, 3, 4)
            waitsFor(allContactsToBeHidden, "all contacts to be hidden", 5000)
          )

          it("should show the contact filters", () ->
            contactsView.filter()

            allFilterFormsToBeVisible = () -> $("#contacts-content form:visible").length == 2
            waitsFor(allFilterFormsToBeVisible, "all filter forms to be visible", 5000)
          )

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

    contactCreationCounter = 0

    createContact = (options) ->
      _.extend({ CoLastName: "A Company #{++contactCreationCounter}", IsIndividual: false, FirstName: "", Type: "Customer", CurrentBalance: 100.00 }, options)

    assertContact = (container, expectedValues) ->
      jqueryContainer = $(container)
      expect(jqueryContainer.find(".name")).toHaveText(expectedValues.name)
      expect(jqueryContainer.find(".type")).toHaveText(expectedValues.type)
      expect(jqueryContainer.find(".balance")).toHaveText(new RegExp(regexEscape(expectedValues.balance)))

    establishNameFilterValue = (value) ->
      $("#contacts-content form.ui-listview-filter input").val(value)

    hasVisibleContactPositions = () ->
      expectedPositions = $.makeArray(arguments)
      actualPositions = positionsFrom($("#contacts-content .contact:not(.ui-screen-hidden)"))
      console.log("**** expected positions: #{JSON.stringify(expectedPositions)}")
      console.log("**** actual positions: #{JSON.stringify(actualPositions)}")
      JSON.stringify(actualPositions) == JSON.stringify(expectedPositions)

    hasHiddenContactPositions = () ->
      expectedPositions = $.makeArray(arguments)
      actualPositions = positionsFrom($("#contacts-content .contact.ui-screen-hidden"))
      JSON.stringify(actualPositions) == JSON.stringify(expectedPositions)

    positionsFrom = (contactElements) ->
      contactElements.map((i, element) -> $(element).data("position")).get()
  )

)
