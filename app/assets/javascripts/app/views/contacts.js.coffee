define([ "jquery",
         "underscore",
         "./base_view",
         "../models/contacts",
         "text!./contacts.tmpl" ], ($, _, BaseView, Contacts, Template) ->

  $("body").append("<div id='contacts' data-role='page' data-title='Contacts'></div>")

  class ContactsView extends BaseView

    initialize: (applicationState) ->
      super
      @compiledTemplate = _.template(Template)
      @contacts = new Contacts().on("reset", @render, this)
                                .on("error", @render, this)

    el: $("#contacts")

    events: () ->
      "pagebeforeshow": "_pageBeforeShow"
      "pageshow": "_showErrorIfNecessary"
      "click .contact": "open"

    update: () ->
      @contacts.fetch()

    prepareDom: () ->
      @$el.html(@compiledTemplate(header: @_headerContent(), contacts: @contacts))

    open: (event) ->
      @applicationState.openedContact = @_contactFrom(event)
      location.hash = "contact_details"

    _headerContent: () ->
      customerFileName = @applicationState.openedCustomerFile.get("Name")
      @renderHeader(
        button: { elementId: "customer-file-logout", href: "#customer_files", label: "Back" },
        title: { elementClass: "customer-file-name", label: customerFileName }
      )

    _pageBeforeShow: () ->
      @_refreshList()
      @_showNoContactsMessageIfNecessary()

    _refreshList: () ->
      $("#contacts-list").listview(
        autodividers: true,
        autodividersSelector: (li) -> $(li).find(".name").text()[0].toUpperCase()
      )

    _showNoContactsMessageIfNecessary: () ->
      if (@contacts.isEmpty()) then @_noContactsMessage().show() else @_noContactsMessage().hide()

    _showErrorIfNecessary: () ->
      $("#contacts-general-error-message").popup().popup("open") if @contacts.fetchError

    _noContactsMessage: () ->
      $("#no-contacts-message")

    _contactFrom: (event) ->
      target = $(event.target)
      target = target.parent() unless target.hasClass("contact")
      @contacts.at(target.data("position"))

)
