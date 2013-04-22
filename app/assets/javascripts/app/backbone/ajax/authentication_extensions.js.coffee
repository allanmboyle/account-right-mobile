define([ "jquery", "underscore" ], ($, _) ->

  extendOptions: (options) ->
    resolvedOptions = _.extend({}, options)
    resolvedOptions.error = (xhr) =>
      response = @_responseIn(xhr)
      if response["liveLoginRequired"] then location.hash = "#live_login" else @_invokeCallback(options, arguments)
    resolvedOptions

  _responseIn: (xhr) ->
    try
      JSON.parse(xhr.responseText)
    catch error
      {}

  _invokeCallback: (options, callbackArguments) ->
    options.error.apply(options.error, callbackArguments) if options.error

)
