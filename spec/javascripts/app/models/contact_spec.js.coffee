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

  describe("#phoneNumbers", () ->

    describe("when an address is present", () ->

      describe("and all three phone numbers are present", () ->

        beforeEach(() ->
          contact = new Contact(Addresses: [ { Index: 1, Phone1: "111111111", Phone2: "222222222", Phone3: "333333333" } ])
        )

        it("should return all three phone numbers", () ->
          expect(contact.phoneNumbers()).toEqual(["111111111", "222222222", "333333333"])
        )

      )

      describe("and a phone number is present", () ->

        beforeEach(() ->
          contact = new Contact(Addresses: [ { Index: 1, Phone1: "", Phone2: "222222222", Phone3: "" } ])
        )

        it("should return the phone number", () ->
          expect(contact.phoneNumbers()).toEqual(["222222222"])
        )

      )

      describe("but no phone numbers are present", () ->

        beforeEach(() ->
          contact = new Contact(Addresses: [ { Index: 1, Street: "Seasame St", Phone1: "", Phone2: "", Phone3: "" } ])
        )

        it("should return an empty array", () ->
          expect(contact.phoneNumbers()).toEqual([])
        )

      )

    )

    describe("when an empty address is present", () ->

      beforeEach(() ->
        contact = new Contact(Addresses: [ { Index: 1, Street: "", City: "", State: "", PostCode: "", Country: "" } ])
      )

      it("should return an empty array", () ->
        expect(contact.phoneNumbers()).toEqual([])
      )

    )

    describe("when no addresses are present", () ->

      beforeEach(() ->
        contact = new Contact(Addresses: [])
      )

      it("should return an empty array", () ->
        expect(contact.phoneNumbers()).toEqual([])
      )

    )

  )

  describe("#addressLines", () ->

    describe("when an address is present", () ->

      describe("and it contains a complete first address", () ->

        beforeEach(() ->
          contact = new Contact(Addresses: [ { Index: 1, Street: "888 Seasame Street", City: "Sydney", State: "NSW", PostCode: "1001", Country: "Australia" } ])
        )

        it("should contain the street in the first line", () ->
          expect(contact.addressLines()[0]).toBe("888 Seasame Street")
        )

        it("should contain the city in the second line", () ->
          expect(contact.addressLines()[1]).toBe("Sydney")
        )

        it("should contain the state, postcode and country on the third line", () ->
          expect(contact.addressLines()[2]).toBe("NSW 1001 Australia")
        )

      )

      describe("and it contains an address without a street", () ->

        beforeEach(() ->
          contact = new Contact(Addresses: [ { Index: 1, Street: "", City: "Sydney", State: "NSW", PostCode: "1001", Country: "Australia" } ])
        )

        it("should only contain 2 lines", () ->
          expect(contact.addressLines().length).toBe(2)
        )

        it("should contain the city in the first line", () ->
          expect(contact.addressLines()[0]).toBe("Sydney")
        )

      )

      describe("and it contains an address without a city", () ->

        beforeEach(() ->
          contact = new Contact(Addresses: [ { Index: 1, Street: "888 Seasame Street", City: "", State: "NSW", PostCode: "1001", Country: "Australia" } ])
        )

        it("should only contain 2 lines", () ->
          expect(contact.addressLines().length).toBe(2)
        )

        it("should have a last line containing the state, postcode and country", () ->
          expect(contact.addressLines()[1]).toBe("NSW 1001 Australia")
        )

      )

      describe("and it contains an address without a state", () ->

        beforeEach(() ->
          contact = new Contact(Addresses: [ { Index: 1, Street: "888 Seasame Street", City: "Sydney", State: "", PostCode: "1001", Country: "Australia" } ])
        )

        it("should only contain the the postcode and country on the third line", () ->
          expect(contact.addressLines()[2]).toBe("1001 Australia")
        )

      )

      describe("and it contains an address without a postcode", () ->

        beforeEach(() ->
          contact = new Contact(Addresses: [ { Index: 1, Street: "888 Seasame Street", City: "Sydney", State: "NSW", PostCode: "", Country: "Australia" } ])
        )

        it("should only contain the state and country on the third line", () ->
          expect(contact.addressLines()[2]).toBe("NSW Australia")
        )

      )

      describe("and it contains an address without a country", () ->

        beforeEach(() ->
          contact = new Contact(Addresses: [ { Index: 1, Street: "888 Seasame Street", City: "Sydney", State: "NSW", PostCode: "1001", Country: "" } ])
        )

        it("should only contain the state and postcode the third line", () ->
          expect(contact.addressLines()[2]).toBe("NSW 1001")
        )

      )

      describe("and it contains an address without a state, postcode and country", () ->

        beforeEach(() ->
          contact = new Contact(Addresses: [ { Index: 1, Street: "888 Seasame Street", City: "Sydney", State: "", PostCode: "", Country: "" } ])
        )

        it("should only contain 2 lines", () ->
          expect(contact.addressLines().length).toBe(2)
        )

        it("should have last line containing the city", () ->
          expect(contact.addressLines()[1]).toBe("Sydney")
        )

      )

    )

    describe("when an empty address is present", () ->

      beforeEach(() ->
        contact = new Contact(Addresses: [ { Index: 1, Street: "", City: "", State: "", PostCode: "", Country: "" } ])
      )

      it("should return an empty array", () ->
        expect(contact.addressLines()).toEqual([])
      )

    )

    describe("when no addresses are present", () ->

      beforeEach(() ->
        contact = new Contact(Addresses: [])
      )

      it("should return an empty array", () ->
        expect(contact.addressLines()).toEqual([])
      )

    )

  )

  describe("#hasAddress", () ->

    describe("when an address is present", () ->

      beforeEach(() ->
        contact = new Contact(Addresses: [ { Index: 1, Street: "888 Seasame Street", City: "", State: "", PostCode: "", Country: "" } ])
      )

      it("should return true", () ->
        expect(contact.hasAddress()).toBe(true)
      )

    )

    describe("when an empty address is present", () ->

      beforeEach(() ->
        contact = new Contact(Addresses: [ { Index: 1, Street: "", City: "", State: "", PostCode: "", Country: "" } ])
      )

      it("should return false", () ->
        expect(contact.hasAddress()).toBe(false)
      )

    )

    describe("when no addresses are present", () ->

      beforeEach(() ->
        contact = new Contact(Addresses: [])
      )

      it("should return false", () ->
        expect(contact.hasAddress()).toBe(false)
      )

    )

  )

)
