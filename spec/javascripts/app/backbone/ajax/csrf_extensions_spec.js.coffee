describe("CSRFExtensions", () ->

  CSRFExtensions = null

  jasmineRequire(this, [ "app/backbone/ajax/csrf_extensions" ], (LoadedCSRFExtensions) ->
    CSRFExtensions = LoadedCSRFExtensions
  )

  describe("#extendOptions", () ->

    beforeEach(() ->
      $("head").append("<meta name='csrf-token' content='some_csrf_token'>")
    )

    afterEach(() ->
      $("meta[name='csrf-token']").remove()
    )

    describe("inclusion of token in requests", () ->

      describe("when a GET request is made", () ->

        it("should return unmodified options", () ->
          options = { type: "GET", url: "/some/url", data: { key: "value" } }

          actualOptions = CSRFExtensions.extendOptions(options)

          expect(actualOptions["type"]).toBe("GET")
          expect(actualOptions["url"]).toBe("/some/url")
          expect(actualOptions["data"]).toEqual(key: "value")
        )

      )

      describe("when another request type is made", () ->

        ["POST", "PUT", "DELETE"].forEach((request_type) ->

          describe("that is a #{request_type}", () ->

            it("should return unmodified non-data options", () ->
              actualOptions = CSRFExtensions.extendOptions(
                headers: { key: "value" }
                type: request_type
                url: "/some/url"
              )

              expect(actualOptions["headers"]).toEqual(key: "value")
              expect(actualOptions["type"]).toBe(request_type)
              expect(actualOptions["url"]).toBe("/some/url")
            )

          )

        )

        describe("when request data is provided", () ->

          it("should return data containing the token", () ->
            actualOptions = CSRFExtensions.extendOptions(type: "POST", data: { key: "value" })

            expect(actualOptions["data"]).toEqual(authenticity_token: "some_csrf_token", key: "value")
          )

        )

        describe("when no request data is provided", () ->

          it("should return data containing the token", () ->
            actualOptions = CSRFExtensions.extendOptions(type: "POST")

            expect(actualOptions["data"]).toEqual(authenticity_token: "some_csrf_token")
          )

        )

      )

    )

    describe("updating the token in the application", () ->

      describe("when the success callback is invoked in the extended options", () ->

        successCallback = null
        response = null

        beforeEach(() ->
          successCallback = jasmine.createSpy("successCallback")
        )

        describe("and a token is included in the response", () ->

          beforeEach(() ->
            response = { "csrf-token": "updated_csrf_token" }
          )

          describe("and a success callback is provided", () ->

            it("should establish the token in the cross-site request forgery meta-tag", () ->
              extendOptionsAndInvokeSuccessCallback(success: successCallback)

              expect($("meta[name='csrf-token']")).toHaveAttr("content", "updated_csrf_token")
            )

            it("should invoke the callback with the response", () ->
              extendOptionsAndInvokeSuccessCallback(success: successCallback)

              expect(successCallback).toHaveBeenCalledWith(response)
            )

          )

          describe("and no success callback is provided", () ->

            it("should establish the token in the cross-site request forgery meta-tag", () ->
              extendOptionsAndInvokeSuccessCallback({})

              expect($("meta[name='csrf-token']")).toHaveAttr("content", "updated_csrf_token")
            )

          )

        )

        describe("and no token is included in the response", () ->

          beforeEach(() ->
            response = { key: "value" }
          )

          it("should not alter the existing value in the cross-site request forgery meta-tag", () ->
            extendOptionsAndInvokeSuccessCallback({})

            expect($("meta[name='csrf-token']")).toHaveAttr("content", "some_csrf_token")
          )

          describe("and a success callback is provided", () ->

            it("should invoke the callback with the response", () ->
              extendOptionsAndInvokeSuccessCallback(success: successCallback)

              expect(successCallback).toHaveBeenCalledWith(response)
            )

          )

        )

        extendOptionsAndInvokeSuccessCallback = (options) ->
          actualOptions = CSRFExtensions.extendOptions(options)
          actualOptions.success(response)

      )

    )

  )

)
