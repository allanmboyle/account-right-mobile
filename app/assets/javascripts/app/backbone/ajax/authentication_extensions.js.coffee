define([ "jquery", "underscore" ], ($, _) ->

  class AuthenticationExtensions

    constructor: (@applicationState) ->

    extendOptions: (options) ->
      resolvedOptions = _.extend({}, options)
      resolvedOptions.error = (xhr) =>
        @_redirectWhenAuthenticationIsRequired(options, arguments)
      resolvedOptions

    _redirectWhenAuthenticationIsRequired: (options, callbackArguments) ->
      loginRequired = @_loginRequiredResponse(callbackArguments[0])
      if loginRequired
        @applicationState.reLoginRequired = true
        location.hash = "##{loginRequired}"
      else
        @_invokeOriginalCallback(options, callbackArguments)

    _loginRequiredResponse: (xhr) ->
      try
        JSON.parse(xhr.responseText)["loginRequired"]
      catch error
        null

    _invokeOriginalCallback: (options, callbackArguments) ->
      options.error.apply(options.error, callbackArguments) if options.error

)
