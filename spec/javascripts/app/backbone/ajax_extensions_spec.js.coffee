describe("AjaxExtensions", () ->

  Backbone =
    ajax: () -> @originalAjax.apply(this, arguments)
    originalAjax: () ->

  CSRFExtensions =
    extendOptions: (options) ->

  AuthenticationExtensions =
    extendOptions: (options) ->

  stubs =
    "backbone": Backbone
    "app/backbone/ajax/csrf_extensions": CSRFExtensions
    "app/backbone/ajax/authentication_extensions": AuthenticationExtensions

  jasmineRequireWithStubs(this, stubs, [ "app/backbone/ajax_extensions" ], (AjaxExtensions) ->
    # Intentionally blank
  )

  describe("#ajax", () ->

    describe("Backbone delegation", () ->

      it("should delegate to Backbone's original ajax support", () ->
        spyOn(Backbone, "originalAjax")

        Backbone.ajax({})

        expect(Backbone.originalAjax).toHaveBeenCalled()
      )

    )

    describe("cross-site request forgery extensions", () ->

      it("should extend the provided options with cross-site request forgery options", () ->
        csrfExtendOptionsMethod = CSRFExtensions.extendOptions = jasmine.createSpy().andReturn({ key: "extendedValue" })
        options = { key: "value" }

        Backbone.ajax(options)

        expect(csrfExtendOptionsMethod).toHaveBeenCalledWith(options)
      )

    )

    describe("authentication extensions", () ->

      csrfExtendedOptions = { key: "csrfValue" }
      authenticationExtendedOptions = { key: "authenticationValue" }
      authenticationExtendOptionsMethod = null

      beforeEach(() ->
        CSRFExtensions.extendOptions = jasmine.createSpy().andReturn(csrfExtendedOptions)
        AuthenticationExtensions.extendOptions = authenticationExtendOptionsMethod =
          jasmine.createSpy().andReturn(authenticationExtendedOptions)
      )

      it("should extend the cross-site request forgery options with authentication options", () ->
        Backbone.ajax(key: "value")

        expect(authenticationExtendOptionsMethod).toHaveBeenCalledWith(csrfExtendedOptions)
      )

      it("should delegate to Baclbone's original ajax support with the authentication options", () ->
        spyOn(Backbone, "originalAjax")

        Backbone.ajax(key: "value")

        expect(Backbone.originalAjax).toHaveBeenCalledWith(authenticationExtendedOptions)
      )

    )

  )

)
