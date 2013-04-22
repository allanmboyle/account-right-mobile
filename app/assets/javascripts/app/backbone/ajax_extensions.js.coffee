define([ "backbone",
         "underscore",
         "./ajax/csrf_extensions",
         "./ajax/authentication_extensions" ], (Backbone, _, CSRFExtensions, AuthenticationExtensions) ->

  originalAjax = Backbone.ajax

  Backbone.ajax = () ->
    url = if (typeof arguments[0]) == "string" then arguments[0] else null
    options = if url then arguments[1] else arguments[0]
    resolvedOptions = CSRFExtensions.extendOptions(options)
    resolvedOptions = AuthenticationExtensions.extendOptions(resolvedOptions)
    originalAjax.apply(Backbone, _.compact([url, resolvedOptions]))

)
