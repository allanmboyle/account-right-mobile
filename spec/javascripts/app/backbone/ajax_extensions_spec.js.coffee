describe("AjaxExtensions", () ->

  Backbone = {
    ajax: () -> @originalAjax.apply(this, arguments)
    originalAjax: () ->
  }

  jasmineRequireWithStubs(this, { "backbone": Backbone }, [ "app/backbone/ajax_extensions" ], (AjaxExtensions) ->
    # Intentionally blank
  )

  describe("#ajax", () ->

    beforeEach(() ->
      $("head").append("<meta name='csrf-token' content='some_csrf_token'>")
    )

    afterEach(() ->
      $("meta[name='csrf-token']").remove()
    )

    it("should delegate to Backbone's original ajax support", () ->
      spyOn(Backbone, "originalAjax")

      Backbone.ajax({})

      expect(Backbone.originalAjax).toHaveBeenCalled()
    )

    describe("when the ajax call is successful", () ->

      successCallback = null
      response = null

      beforeEach(() ->
        successCallback = jasmine.createSpy("successCallback")
      )

      describe("and a cross-site request forgery token is included in the response", () ->

        beforeEach(() ->
          response = { "csrf-token": "updated_csrf_token" }
          spyOn(Backbone, "originalAjax").andCallFake((options) -> options.success(response))
        )

        describe("and a success callback is provided", () ->

          it("should invoke the callback with the response", () ->
            Backbone.ajax(success: successCallback)

            expect(successCallback).toHaveBeenCalledWith(response)
          )

          it("should establish the token in the cross-site request forgery meta-tag", () ->
            Backbone.ajax(success: successCallback)

            expect($("meta[name='csrf-token']")).toHaveAttr("content", "updated_csrf_token")
          )

        )

        describe("and no success callback is provided", () ->

          it("should establish the token in the cross-site request forgery meta-tag", () ->
            Backbone.ajax({})

            expect($("meta[name='csrf-token']")).toHaveAttr("content", "updated_csrf_token")
          )

        )

      )

      describe("and no cross-site request forgery token is included in the response", () ->

        beforeEach(() ->
          response = { key: "value" }
          spyOn(Backbone, "originalAjax").andCallFake((options) -> options.success(response))
        )

        describe("and a success callback is provided", () ->

          it("should invoke the callback with the response", () ->
            Backbone.ajax(success: successCallback)

            expect(successCallback).toHaveBeenCalledWith(response)
          )

        )

        it("should not alter the existing value in the cross-site request forgery meta-tag", () ->
          Backbone.ajax({})

          expect($("meta[name='csrf-token']")).toHaveAttr("content", "some_csrf_token")
        )

      )

    )

    describe("when a GET request is made", () ->

      it("should delegate to Backbone's ajax support with unmodified options", () ->
        options = { type: "GET", url: "/some/url", data: { key: "value" } }
        spyOn(Backbone, "originalAjax")

        Backbone.ajax(options)

        actualOptions = Backbone.originalAjax.mostRecentCall.args[0]
        expect(actualOptions["type"]).toBe("GET")
        expect(actualOptions["url"]).toBe("/some/url")
        expect(actualOptions["data"]).toEqual(key: "value")
      )

    )

    describe("when a non-GET request is made", () ->

      beforeEach(() ->
        spyOn(Backbone, "originalAjax")
      )

      ["POST", "PUT", "DELETE"].forEach((request_type) ->

        describe("that is a #{request_type}", () ->

          it("should delegate to Backbone's ajax support without modifying options other than data", () ->
            errorCallback = () -> "some error callback"

            Backbone.ajax(
              type: request_type
              url: "/some/url"
              error: errorCallback
            )

            actualOptions = Backbone.originalAjax.mostRecentCall.args[0]
            expect(actualOptions["type"]).toBe(request_type)
            expect(actualOptions["url"]).toBe("/some/url")
            expect(actualOptions["error"]).toBe(errorCallback)
          )

        )

      )

      describe("when no request data is provided", () ->

        it("should delegate to Backbone with data containing the Rails cross-site request forgery token", () ->
          Backbone.ajax(type: "POST")

          data = Backbone.originalAjax.mostRecentCall.args[0]["data"]
          expect(data).toEqual(authenticity_token: "some_csrf_token")
        )

      )

      describe("when request data is provided", () ->

        it("should delegate to Backbone with the Rails cross-site request forgery token added to the data", () ->
          Backbone.ajax(type: "POST", data: { key: "value" })

          data = Backbone.originalAjax.mostRecentCall.args[0]["data"]
          expect(data).toEqual(authenticity_token: "some_csrf_token", key: "value")
        )

      )

    )

  )

)
