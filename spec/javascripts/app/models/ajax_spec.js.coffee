describe("Ajax", () ->

  Backbone = null
  Ajax = null

  jasmineRequire(this, [ "backbone", "app/models/ajax" ], (LoadedBackbone, LoadedAjax) ->
    Backbone = LoadedBackbone
    Ajax = LoadedAjax
  )

  describe("#submit", () ->

    beforeEach(() ->
      $("head").append("<meta name='csrf-token' content='some_csrf_token'>")

      spyOn(Backbone, "ajax")
    )

    afterEach(() ->
      $("meta[name='csrf-token']").remove()
    )

    it("should delegate to Backbone's ajax support", () ->
      Ajax.submit({})

      expect(Backbone.ajax).toHaveBeenCalled()
    )

    describe("when a GET request is made", () ->

      it("should delegate to Backbone's ajax support without modifying attributes", () ->
        options = { type: "GET", key: "value" }

        Ajax.submit(options)

        expect(Backbone.ajax).toHaveBeenCalledWith(options)
      )

    )

    describe("when a non-GET request is made", () ->

      ["POST", "PUT", "DELETE"].forEach((request_type) ->

        describe("that is a #{request_type}", () ->

          it("should delegate to Backbone's ajax support without modifying attributes other than data", () ->
            successCallback = () -> "some success callback"
            errorCallback = () -> "some error callback"

            Ajax.submit(
              type: request_type
              url: "/some_callback"
              success: successCallback
              error: errorCallback
            )

            actualOptions = Backbone.ajax.mostRecentCall.args[0]
            expect(actualOptions["type"]).toBe(request_type)
            expect(actualOptions["url"]).toBe("/some_callback")
            expect(actualOptions["success"]).toBe(successCallback)
            expect(actualOptions["error"]).toBe(errorCallback)
          )

        )

      )

      describe("when no request data is provided", () ->

        it("should add an authenticity token to the data that contains the Rails csrf token", () ->
          Ajax.submit(type: "POST")

          data = Backbone.ajax.mostRecentCall.args[0]["data"]
          expect(data).toEqual(authenticity_token: "some_csrf_token")
        )

      )

      describe("when request data is provided", () ->

        it("should add an authenticity token to the data that contains the Rails csrf token", () ->
          Ajax.submit(type: "POST", data: { key: "value" })

          data = Backbone.ajax.mostRecentCall.args[0]["data"]
          expect(data).toEqual(authenticity_token: "some_csrf_token", key: "value")
        )

      )

    )

  )

)
