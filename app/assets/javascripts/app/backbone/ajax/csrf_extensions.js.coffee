define([ "jquery", "underscore" ], ($, _) ->

  extendOptions: (options) ->
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

)
