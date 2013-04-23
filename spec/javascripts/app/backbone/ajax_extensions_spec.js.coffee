describe("AjaxExtensions", () ->

  Backbone =
    ajax: () -> @originalAjax.apply(this, arguments)
    originalAjax: () ->

  class ApplicationState

  applicationState = null
  ajaxExtensions = null
  csrfExtensions = null
  authenticationExtensions = null

  stubs =
    "backbone": Backbone
    "app/models/application_state": ApplicationState

  jasmineRequireWithStubs(this, stubs, [ "app/backbone/ajax_extensions" ], (AjaxExtensions) ->
    if !ajaxExtensions
      applicationState = new ApplicationState()
      ajaxExtensions = new AjaxExtensions(applicationState)
      csrfExtensions = ajaxExtensions.csrfExtensions
      authenticationExtensions = ajaxExtensions.authenticationExtensions
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
        csrfExtendOptionsMethod = csrfExtensions.extendOptions = jasmine.createSpy().andReturn({ key: "extendedValue" })
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
        csrfExtensions.extendOptions = jasmine.createSpy().andReturn(csrfExtendedOptions)
        authenticationExtensions.extendOptions = authenticationExtendOptionsMethod =
          jasmine.createSpy().andReturn(authenticationExtendedOptions)
      )

      it("should be provided the application state", () ->
        expect(authenticationExtensions.applicationState).toBe(applicationState)
      )

      it("should extend the cross-site request forgery options with authentication options", () ->
        Backbone.ajax(key: "value")

        expect(authenticationExtendOptionsMethod).toHaveBeenCalledWith(csrfExtendedOptions)
      )

      it("should delegate to Backbone's original ajax support with the authentication options", () ->
        spyOn(Backbone, "originalAjax")

        Backbone.ajax(key: "value")

        expect(Backbone.originalAjax).toHaveBeenCalledWith(authenticationExtendedOptions)
      )

    )

  )

)
