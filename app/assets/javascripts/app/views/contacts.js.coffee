define([ "backbone",
         "jquery",
         "underscore",
         "../models/contacts",
         "text!./contacts_layout.tmpl",
         "text!./contacts_content.tmpl"], (Backbone, $, _, Contacts, LayoutTemplate, ContentTemplate) ->

  $("body").append("<div id='contacts' data-role='page' data-title='Contacts'></div>")

  class ContactsView extends Backbone.View

    initialize: () ->
      @compiledContentTemplate = _.template(ContentTemplate)
      @contacts = new Contacts()
      @$el.html(_.template(LayoutTemplate))

    el: $("#contacts")

    events: () ->
      "pagebeforeshow": "pageBeforeShow"
      "pageshow": "showErrorIfNecessary"

    update: () ->
      @contacts.on("reset", @render, this).on("error", @render, this)
      @contacts.fetch()

    render: () ->
      $("#contacts-content").html(@compiledContentTemplate(contacts: @contacts))
      $.mobile.changePage("#contacts", reverse: false, changeHash: false)
      this

    pageBeforeShow: () ->
      @_refreshAutoDividers()
      @_showNoContactsMessageIfNecessary()

    showErrorIfNecessary: () ->
      $("#contacts-general-error-message").popup().popup("open") if @contacts.fetchError

    _refreshAutoDividers: () ->
      $("#contacts-list").listview(autodividers: true,
                                   autodividersSelector: (li) -> $(li).find(".name").text()[0].toUpperCase())
      $("#contacts-list").listview("refresh")

    _showNoContactsMessageIfNecessary: () ->
      if (@contacts.isEmpty()) then @_noContactsMessage().show() else @_noContactsMessage().hide()

    _noContactsMessage: () ->
      $("#no-contacts-message")

)
