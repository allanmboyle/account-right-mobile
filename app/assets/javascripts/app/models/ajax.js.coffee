define([ "jquery", "backbone", "underscore" ], ($, Backbone, _) ->

  submit: (options) ->
    resolvedOptions = if (options["type"] == "GET") then options else @_addAuthenticityTokenTo(options)
    Backbone.ajax(resolvedOptions)

  _addAuthenticityTokenTo: (options) ->
    resolvedOptions = _.extend({ data: {} }, options)
    _.extend(resolvedOptions["data"], { authenticity_token: @_csrfToken() })
    resolvedOptions

  _csrfToken: () ->
    $('meta[name="csrf-token"]').attr("content")

)
