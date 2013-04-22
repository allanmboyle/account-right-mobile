define([ "jquery", "backbone", "underscore" ], ($, Backbone, _) ->

  originalAjax = Backbone.ajax

  AjaxExtensions = {

    ajax: () ->
      url = if (typeof arguments[0]) == "string" then arguments[0] else null
      options = if url then arguments[1] else arguments[0]
      resolvedOptions = @_withAuthenticityTokenSupport(options)
      originalAjax.apply(Backbone, _.compact([url, resolvedOptions]))

    _withAuthenticityTokenSupport: (options) ->
      resolvedOptions = if (options.type != "GET") then @_withAuthenticityTokenInData(options) else options
      @_withAuthenticityTokenUpdatedOnSuccess(resolvedOptions)

    _withAuthenticityTokenInData: (options) ->
      resolvedOptions = _.extend({ data: {} }, options)
      _.extend(resolvedOptions.data, { authenticity_token: @_csrfTokenTag().attr("content") })
      resolvedOptions

    _withAuthenticityTokenUpdatedOnSuccess: (options) ->
      resolvedOptions = _.extend({}, options)
      resolvedOptions.success = (response) =>
        @_csrfTokenTag().attr("content", response["csrf-token"]) if response && response["csrf-token"]
        options.success(response) if options.success
      resolvedOptions

    _csrfTokenTag: () -> $("meta[name='csrf-token']")

  }

  Backbone.ajax = () ->
    AjaxExtensions.ajax.apply(AjaxExtensions, arguments)

)
