define([ "backbone",
         "underscore",
         "./ajax/csrf_extensions",
         "./ajax/authentication_extensions" ], (Backbone, _, CSRFExtensions, AuthenticationExtensions) ->

  class AjaxExtensions

    constructor: (applicationState) ->
      @csrfExtensions = new CSRFExtensions()
      @authenticationExtensions = new AuthenticationExtensions(applicationState)
      originalAjax = Backbone.ajax
      Backbone.ajax = () =>
        url = if (typeof arguments[0]) == "string" then arguments[0] else null
        options = if url then arguments[1] else arguments[0]
        resolvedOptions = @authenticationExtensions.extendOptions(@csrfExtensions.extendOptions(options))
        originalAjax.apply(Backbone, _.compact([url, resolvedOptions]))

)
