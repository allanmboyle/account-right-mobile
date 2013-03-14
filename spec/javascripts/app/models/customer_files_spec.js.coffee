describe("CustomerFiles", () ->

  Backbone = null
  customerFiles = null

  jasmineRequire(this, [ "backbone", "app/models/customer_files" ], (LoadedBackbone, CustomerFiles) ->
    Backbone = LoadedBackbone
    customerFiles = new CustomerFiles()
  )

  describe("#fetch", () ->

    it("should contact the server to fetch the customer files", () ->
      spyOn(Backbone, "ajax")

      customerFiles.fetch()

      requestType = Backbone.ajax.mostRecentCall.args[0]["type"]
      requestUrl = Backbone.ajax.mostRecentCall.args[0]["url"]
      expect(requestType).toEqual("GET")
      expect(requestUrl).toEqual("/api/accountright")
    )

    it("should be populated by the servers response", () ->
      spyOn(Backbone, "ajax").andCallFake((options) ->
        options.success([ { "Name": "File 1" }, { "Name": "File 2" }, { "Name": "File 3" } ])
      )

      customerFiles.fetch()

      customerFileNames = customerFiles.map((customerFile) -> customerFile.get("Name"))
      expect(customerFileNames).toEqual(["File 1", "File 2", "File 3"])
    )

  )

)
