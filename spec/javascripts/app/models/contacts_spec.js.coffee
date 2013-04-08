describe("Contacts", () ->

  Backbone = null
  contacts = null

  jasmineRequire(this, [ "backbone", "app/models/contacts" ], (LoadedBackbone, Contacts) ->
    Backbone = LoadedBackbone
    contacts = new Contacts()
  )

  describe("#fetch", () ->

    it("should contact the server to fetch the contacts", () ->
      spyOn(Backbone, "ajax")

      contacts.fetch()

      requestType = Backbone.ajax.mostRecentCall.args[0]["type"]
      requestUrl = Backbone.ajax.mostRecentCall.args[0]["url"]
      expect(requestType).toEqual("GET")
      expect(requestUrl).toEqual("/contact")
    )

    it("should be populated by the servers response and automatically sorted by the case insensitve CoLastName", () ->
      spyOn(Backbone, "ajax").andCallFake((options) ->
        options.success([ { "CoLastName": "a Last Name", "FirstName": "FirstName 1", "IsIndividual": true, "Type": "Type 1", "CurrentBalance": 100.00 },
                          { "CoLastName": "Some Company Name", "FirstName": "", "IsIndividual": false, "Type": "Type 2", "CurrentBalance": 200.00 },
                          { "CoLastName": "Another Last Name", "FirstName": "FirstName 3", "IsIndividual": true, "Type": "Type 3", "CurrentBalance": 300.00 } ])
      )

      contacts.fetch()

      contactCoLastNames = contacts.map((contact) -> contact.get("CoLastName"))
      contactFirstNames = contacts.map((contact) -> contact.get("FirstName"))
      contactIsIndividualValues = contacts.map((contact) -> contact.get("IsIndividual"))
      contactTypes = contacts.map((contact) -> contact.get("Type"))
      contactCurrentBalances = contacts.map((contact) -> contact.get("CurrentBalance"))
      expect(contactCoLastNames).toEqual(["a Last Name", "Another Last Name", "Some Company Name"])
      expect(contactFirstNames).toEqual(["FirstName 1", "FirstName 3", ""])
      expect(contactIsIndividualValues).toEqual([true, true, false])
      expect(contactTypes).toEqual(["Type 1", "Type 3", "Type 2"])
      expect(contactCurrentBalances).toEqual([100.00, 300.00, 200.00])
    )

  )

)
