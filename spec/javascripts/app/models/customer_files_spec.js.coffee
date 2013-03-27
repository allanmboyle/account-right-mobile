describe("CustomerFiles", () ->

  Backbone = null
  customerFiles = null
  CustomerFile = null
  customerFileUser = null

  jasmineRequire(this, [ "backbone",
                         "app/models/customer_files",
                         "app/models/customer_file",
                         "app/models/customer_file_user" ], (LoadedBackbone, CustomerFiles,
                                                             LoadedCustomerFile, CustomerFileUser) ->
    Backbone = LoadedBackbone
    customerFiles = new CustomerFiles()
    CustomerFile = LoadedCustomerFile
    customerFileUser = new CustomerFileUser()
  )

  describe("#fetch", () ->

    it("should contact the server to fetch the customer files", () ->
      spyOn(Backbone, "ajax")

      customerFiles.fetch()

      requestType = Backbone.ajax.mostRecentCall.args[0]["type"]
      requestUrl = Backbone.ajax.mostRecentCall.args[0]["url"]
      expect(requestType).toEqual("GET")
      expect(requestUrl).toEqual("/customer_file")
    )

    it("should be populated by the servers response", () ->
      spyOn(Backbone, "ajax").andCallFake((options) ->
        options.success([ { "Id": "1", "Name": "File 1"},
                          { "Id": "2", "Name": "File 2" },
                          { "Id": "3", "Name": "File 3" } ])
      )

      customerFiles.fetch()

      customerFileIds = customerFiles.map((customerFile) -> customerFile.get("Id"))
      customerFileNames = customerFiles.map((customerFile) -> customerFile.get("Name"))
      expect(customerFileIds).toEqual(["1", "2", "3"])
      expect(customerFileNames).toEqual(["File 1", "File 2", "File 3"])
    )

  )

  describe("when a number of files have been added", () ->

    beforeEach(() ->
      customerFiles.add([ new CustomerFile(Id: "1", Name: "Name 1"),
                          new CustomerFile(Id: "2", Name: "Name 2"),
                          new CustomerFile(Id: "3", Name: "Name 3") ])
    )

    describe("#expandedFile", () ->

      describe("when a position is marked as expanded", () ->

        beforeEach(() ->
          customerFiles.expandedPosition = 1
        )

        it("should return the expanded file", () ->
          expect(customerFiles.expandedFile()).toBe(customerFiles.at(1))
        )

      )

    )

  )

  describe("#login", () ->

    expandedFile = null

    beforeEach(() ->
      customerFiles.expandedPosition = 1
      expandedFile = customerFiles.expandedFile()
    )

    it("should login the provided user to the expanded file", () ->
      spyOn(customerFileUser, "loginTo")

      customerFiles.login(customerFileUser)

      expect(customerFileUser.loginTo).toHaveBeenCalledWith(expandedFile)
    )

  )

)
