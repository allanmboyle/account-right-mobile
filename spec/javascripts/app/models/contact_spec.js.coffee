describe("Contact", () ->

  Contact = null
  contact = null

  jasmineRequire(this, [ "app/models/contact" ], (LoadedContact) ->
    Contact = LoadedContact
  )

  describe("#name", () ->

    describe("when the contact is a company", () ->

      beforeEach(() ->
        contact = new Contact({ CoLastName: "A Company", FirstName: "", IsIndividual: false, Type: "Customer", CurrentBalance: 100.00 })
      )

      it("should return the company name", () ->
        expect(contact.name()).toBe("A Company")
      )

    )

    describe("when the contact is an individual", () ->

      beforeEach(() ->
        contact = new Contact({ CoLastName: "Pelovic", FirstName: "Sasha", IsIndividual: true, Type: "Supplier", CurrentBalance: 100.00 })
      )

      it("should return both the last and first name with the last name first", () ->
        expect(contact.name()).toBe("Pelovic, Sasha")
      )

    )

  )

)
