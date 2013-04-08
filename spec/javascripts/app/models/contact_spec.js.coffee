describe("Contact", () ->

  Contact = null
  contact = null

  jasmineRequire(this, [ "app/models/contact" ], (LoadedContact) ->
    Contact = LoadedContact
  )

  describe("#name", () ->

    describe("when the contact is a company", () ->

      beforeEach(() ->
        contact = new Contact(CoLastName: "A Company", FirstName: "", IsIndividual: false, Type: "Customer", CurrentBalance: 100.00)
      )

      it("should return the company name", () ->
        expect(contact.name()).toBe("A Company")
      )

    )

    describe("when the contact is an individual", () ->

      beforeEach(() ->
        contact = new Contact(CoLastName: "Pelovic", FirstName: "Sasha", IsIndividual: true, Type: "Supplier", CurrentBalance: 100.00)
      )

      it("should return both the last and first name with the last name first", () ->
        expect(contact.name()).toBe("Pelovic, Sasha")
      )

    )

  )

  describe("#balanceDescription", () ->

    describe("when a contacts balance is negative", () ->

      beforeEach(() -> 
        contact = createContactWithBalance(-1)
      )

      it("should return a string containing 'I owe'", () ->
        expect(contact.balanceDescription()).toContain("I owe")
      )

      it("should display the negative balance as a positive number", () ->
        expect(contact.balanceDescription()).not.toContain("-1")
        expect(contact.balanceDescription()).toContain("1")
      )

    )

    describe("when a contacts balance is positive", () ->

      beforeEach(() ->
        contact = createContactWithBalance(1)
      )

      it("should return a string containing 'They owe'", () ->
        expect(contact.balanceDescription()).toContain("They owe")
      )

    )

    describe("when a contacts balance is zero", () ->

      beforeEach(() ->
        contact = createContactWithBalance(0)
      )

      it("should return a string containing 'They owe'", () ->
        expect(contact.balanceDescription()).toContain("They owe")
      )

    )

    createContactWithBalance = (balance) ->
      new Contact(CoLastName: "Pelovic", FirstName: "Sasha", IsIndividual: true, Type: "Supplier", CurrentBalance: balance)

  )

)
