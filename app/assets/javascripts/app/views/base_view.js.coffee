define([ "jquery", "backbone", "underscore", "text!./header.tmpl" ], ($, Backbone, _, HeaderTemplate) ->

  class BaseView extends Backbone.View

    render: () ->
      @$el.page().page("destroy").empty()
      @prepareDom()
      $.mobile.changePage("##{@$el.attr("id")}", reverse: false, changeHash: false)
      this

    renderHeader: (options) ->
      resolvedOptions = _.extend({}, options)
      resolvedOptions["header"] = @_headerOptions(options)
      resolvedOptions["button"] = @_buttonOptions(options["button"] || {})
      resolvedOptions["title"] = @_titleOptions(options["title"])
      @compiledHeaderTemplate ?= _.template(HeaderTemplate)
      @compiledHeaderTemplate(resolvedOptions)

    _headerOptions: (options) ->
      { elementClass: @_optionalAttribute("class", options["elementClass"]) }

    _buttonOptions: (options) ->
      _.extend(options, { isShown: !_.isEmpty(options), elementId: @_optionalAttribute("id", options["elementId"]) })

    _titleOptions: (options) ->
      _.extend(options, { elementClass: @_optionalAttribute("class", options["elementClass"]) })

    _optionalAttribute: (name, value) ->
      if value then "#{name}=\"#{value}\"" else ""

)
