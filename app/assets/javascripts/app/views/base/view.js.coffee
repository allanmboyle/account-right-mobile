define([ "jquery", "backbone", "underscore", "text!./header.tmpl" ], ($, Backbone, _, HeaderTemplate) ->

  class BaseView extends Backbone.View

    initialize: (@applicationState, @filters=[]) ->

    additionalEvents: {}

    events: () ->
      _.extend({ "pagebeforecreate": "prepareDom" }, @additionalEvents)

    renderOptions: {}

    render: () ->
      if (@_executeFilters())
        $.mobile.changePage(@$el, _.extend({}, @_defaultRenderOptions, @renderOptions))

    renderHeader: (options) ->
      resolvedOptions = _.extend({}, options)
      resolvedOptions["header"] = @_headerOptions(options)
      resolvedOptions["button"] = @_buttonOptions(options["button"] || {})
      resolvedOptions["title"] = @_titleOptions(options["title"])
      @compiledHeaderTemplate ?= _.template(HeaderTemplate)
      @compiledHeaderTemplate(resolvedOptions)

    prepareDom: () ->
      # Override as required

    _defaultRenderOptions:
      changeHash: false
      reverse: false
      allowSamePageTransition: true
      reloadPage: true

    _headerOptions: (options) ->
      { elementClass: @_optionalAttribute("class", options["elementClass"]) }

    _buttonOptions: (options) ->
      _.extend(options, { isShown: !_.isEmpty(options), elementId: @_optionalAttribute("id", options["elementId"]) })

    _titleOptions: (options) ->
      _.extend(options, { elementClass: @_optionalAttribute("class", options["elementClass"]) })

    _optionalAttribute: (name, value) ->
      if value then "#{name}=\"#{value}\"" else ""

    _executeFilters: () ->
      !_.find(@filters, (filter) => !filter.filter(this))

)
