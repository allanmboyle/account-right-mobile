describe("CustomerFile", () ->

  customerFile = null

  jasmineRequire(this, [ "app/models/customer_file" ], (CustomerFile) ->
    customerFile = new CustomerFile()
  )

  describe("#isEmpty", () ->

    describe("when no attribute values have been established", () ->

      it("should return true", () ->
        expect(customerFile.isEmpty()).toBeTruthy()
      )

    )

    describe("when attribute values have been established", () ->

      beforeEach(() ->
        customerFile.set("Id", "some-id")
        customerFile.set("Name", "Some File Name")
      )

      it("should return false", () ->
        expect(customerFile.isEmpty()).toBeFalsy()
      )

    )

  )

)
