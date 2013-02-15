describe("ContactsView", () ->

  ContactsView = null
  Contact = null

  specRequire(this, [ "jquerymobile",
                      "backbone",
                      "app/views/contacts",
                      "app/models/contact" ], (jqm, Backbone, LoadedContactsView, LoadedContact) ->
    ContactsView = LoadedContactsView
    Contact = LoadedContact
  )

  describe("when loaded", () ->

    it("should add a page placeholder to the dom", () ->
      expect($("#contacts")).toExist()
    )

  )

  describe("when instantiated", () ->

    contactsView = null
    contact = null

    beforeEach(() ->
      contactsView = new ContactsView()
      contact = new Contact()
    )

    describe("#update", () ->

      it("should place the retrieved contacts in the dom", () ->
        response = [{ name: "A Name", type: "Customer", balance: 100.00 },
                    { name: "B Name", type: "Supplier", balance: -100.00 },
                    { name: "C Name", type: "Customer", balance: 200.00 }]

        spyOn(Backbone, "sync").andCallFake((method, model, options) ->
          options.success(response)
        )

        contactsView.update()

        contacts = $(".contact")
        assertContact(contacts[0], { name: "A Name", type: "Customer", balance: "100.00" })
        assertContact(contacts[1], { name: "B Name", type: "Supplier", balance: "100.00" })
        assertContact(contacts[2], { name: "C Name", type: "Customer", balance: "200.00" })
      )

      assertContact = (container, expectedValues) ->
        jqueryContainer = $(container)
        expect(jqueryContainer.find(".name")).toHaveText(expectedValues.name)
        expect(jqueryContainer.find(".contact-type")).toHaveText(expectedValues.type)
        expect(jqueryContainer.find(".balance")).toHaveText(new RegExp(regexEscape(expectedValues.balance)))
    )

    describe("#balanceDescription", () ->

      describe("when a contacts balance is negative", () ->

        beforeEach(() ->
          contact.set(balance: -1)
        )

        it("should return a string containing 'I owe'", () ->
          expect(contactsView.balanceDescription(contact)).toContain("I owe")
        )

        it("should display the negative balance as a positive number", () ->
          expect(contactsView.balanceDescription(contact)).not.toContain("-1")
          expect(contactsView.balanceDescription(contact)).toContain("1")
        )

      )

      describe("when a contacts balance is positive", () ->

        beforeEach(() ->
          contact.set(balance: 1)
        )

        it("should return a string containing 'They owe'", () ->
          expect(contactsView.balanceDescription(contact)).toContain("They owe")
        )

      )

      describe("when a contacts balance is zero", () ->

        beforeEach(() ->
          contact.set(balance: 0)
        )

        it("should return a string containing 'They owe'", () ->
          expect(contactsView.balanceDescription(contact)).toContain("They owe")
        )

      )

    )

  )

)