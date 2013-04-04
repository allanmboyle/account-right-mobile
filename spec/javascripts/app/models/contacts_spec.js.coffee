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

    it("should be populated by the servers response", () ->
      spyOn(Backbone, "ajax").andCallFake((options) ->
        options.success([ { "CoLastName": "CoLastName 1", "FirstName": "FirstName 1", "IsIndividual": true, "Type": "Type 1", "CurrentBalance": 100.00 },
                          { "CoLastName": "CoLastName 2", "FirstName": "FirstName 2", "IsIndividual": false, "Type": "Type 2", "CurrentBalance": 200.00 },
                          { "CoLastName": "CoLastName 3", "FirstName": "FirstName 3", "IsIndividual": true, "Type": "Type 3", "CurrentBalance": 300.00 } ])
      )

      contacts.fetch()

      contactCoLastNames = contacts.map((contact) -> contact.get("CoLastName"))
      contactFirstNames = contacts.map((contact) -> contact.get("FirstName"))
      contactIsIndividualValues = contacts.map((contact) -> contact.get("IsIndividual"))
      contactTypes = contacts.map((contact) -> contact.get("Type"))
      contactCurrentBalances = contacts.map((contact) -> contact.get("CurrentBalance"))
      expect(contactCoLastNames).toEqual(["CoLastName 1", "CoLastName 2", "CoLastName 3"])
      expect(contactFirstNames).toEqual(["FirstName 1", "FirstName 2", "FirstName 3"])
      expect(contactIsIndividualValues).toEqual([true, false, true])
      expect(contactTypes).toEqual(["Type 1", "Type 2", "Type 3"])
      expect(contactCurrentBalances).toEqual([100.00, 200.00, 300.00])
    )

  )

)
