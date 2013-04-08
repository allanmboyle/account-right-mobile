describe("BaseCollection", () ->

  collection = null

  jasmineRequire(this, [ "app/models/base_collection" ], (BaseCollection) ->
    class TestableCollection extends BaseCollection
      url: "/some/url"

    collection = new TestableCollection()
  )

  describe("#fetch", () ->

    describe("when no error occurs", () ->

      beforeEach(() ->
        spyOn(Backbone, "ajax").andCallFake((options) -> options.success())
      )

      it("should establish a fetchError flag whose value is false", () ->
        collection.fetch()

        expect(collection.fetchError).toBe(false)
      )

    )

    describe("when an error occurs", () ->

      beforeEach(() ->
        spyOn(Backbone, "ajax").andCallFake((options) -> options.error())
      )

      it("should establish a fetchError flag whose value is true", () ->
        collection.fetch()

        expect(collection.fetchError).toBe(true)
      )

      describe("and a customer error event handler is configured", () ->

        errorCallbackCalled = false

        beforeEach(() ->
          errorCallback = () -> errorCallbackCalled = true
          collection.on("error", errorCallback)
        )

        it("should establish a fetchError flag whose value is true", () ->
          collection.fetch()

          expect(collection.fetchError).toBe(true)
        )

        it("should invoke the error event handler", () ->
          collection.fetch()

          errorCallbackToBeInvoked = () -> errorCallbackCalled
          waitsFor(errorCallbackToBeInvoked, "Error callback to be invoked", 5000)
        )

      )

    )

    describe("when an error occurred in the previous call", () ->

      beforeEach(() ->
        collection.fetchError = true
      )

      describe("and no error occurs in a subsequent call", () ->

        beforeEach(() ->
          spyOn(Backbone, "ajax").andCallFake((options) -> options.success())
        )

        it("should update the fetchError flag to false", () ->
          collection.fetch()

          expect(collection.fetchError).toBe(false)
        )

      )

    )

  )

)
