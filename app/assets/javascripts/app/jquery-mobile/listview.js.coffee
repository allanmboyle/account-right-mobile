define([ "jquery", "underscore" ], ($, _) ->

  class Listview

    constructor: (selector, options) ->
      @element = $(selector).listview(options)
      @searchElement = @element.parent().find($("form input[data-type=search]"))
      @clearElement = @element.parent().find($("form .ui-listview-filter .ui-input-clear-hidden"))
      @filterCallback = options["filterCallback"]
      @_bindFilter()

    # Exposes internals from jquery-mobile/js/widgets/listview.filter.js
    filter: () ->
      childItems = false
      items = @element.children()
      _.each(items.get().reverse(), (rawItem) =>
        item = $(rawItem)
        if item.is("li:jqmData(role=list-divider)")
          item.toggleClass("ui-filter-hidequeue", !childItems)
          childItems = false
        else if (@filterCallback(item))
          item.toggleClass("ui-filter-hidequeue", true)
        else
          childItems = true
      )
      @_showItemsNotAddedToHideQueue(items)
      @_hideItemsAddedToHideQueue(items)

    _bindFilter: () ->
      @_unbindDefaultFilter()
      @searchElement.on("keyup change input", () =>
        @clearElement.toggleClass("ui-input-clear-hidden", _.isEmpty(@searchElement.val()))
        @filter()
      )

    _unbindDefaultFilter: () ->
      @searchElement.unbind()

    _showItemsNotAddedToHideQueue: (items) ->
      items.filter(":not(.ui-filter-hidequeue)")
        .toggleClass("ui-screen-hidden", false)

    _hideItemsAddedToHideQueue: (items) ->
      items.filter(".ui-filter-hidequeue")
        .toggleClass("ui-screen-hidden", true)
        .toggleClass("ui-filter-hidequeue", false)

)
