define([ "jquery",
         "underscore",
         "./base/view",
         "../jquery-mobile/listview"
         "./filters/require_live_login",
         "./filters/require_customer_file_login",
         "../models/contacts",
         "text!./contacts.tmpl" ], ($, _, BaseView, Listview,
                                    RequireLiveLoginFilter, RequireCustomerFileLoginFilter,
                                    Contacts, Template) ->

  $("body").append("<div id='contacts' data-role='page' data-title='Contacts'></div>")

  class ContactsView extends BaseView

    initialize: (applicationState) ->
      super(applicationState, [ new RequireLiveLoginFilter(), new RequireCustomerFileLoginFilter() ])
      @compiledTemplate = _.template(Template)
      @contacts = new Contacts().on("reset", @render, this)
                                .on("error", @render, this)

    el: $("#contacts")

    events: () ->
      "pagebeforeshow": "_pageBeforeShow"
      "pageshow": "_showErrorIfNecessary"
      "change input[name='balance-filter']": "filter"
      "click .contact": "open"

    liveLoginRequired: true

    update: () ->
      @contacts.fetch()

    prepareDom: () ->
      @$el.html(@compiledTemplate(header: @_headerContent(), contacts: @contacts))
      @_balanceFilters = @$el.find("input[name='balance-filter']")
      @_noContactsMessage = @$el.find("#no-contacts-message")

    filter: () ->
      @listview.filter()

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
      @_hideFiltersIfNecessary()
      @_showNoContactsMessageIfNecessary()

    _refreshList: () ->
      listviewOptions =
        autodividers: true
        autodividersSelector: (li) -> $(li).find(".name").text()[0].toUpperCase()
        filterCallback: (item) => @_filterContact(item)
      @listview = new Listview("#contacts-list", listviewOptions)

    _hideFiltersIfNecessary: () ->
      @$el.find("form").hide() if @contacts.isEmpty()

    _showNoContactsMessageIfNecessary: () ->
      if (@contacts.isEmpty()) then @_noContactsMessage.show() else @_noContactsMessage.hide()

    _showErrorIfNecessary: () ->
      $("#contacts-general-error-message").popup("open") if @contacts.fetchError

    _filterContact: (element) ->
      balanceMethod = @_balanceFilters.filter(":checked").val()
      searchInput = @listview.searchElement.val().toLowerCase()
      contact = @contacts.at(element.data("position"))
      contact.name().toLowerCase().indexOf(searchInput) == -1 ||
        (!_.isEmpty(balanceMethod) && !contact[balanceMethod].apply(contact, null))

    _contactFrom: (event) ->
      target = $(event.target)
      target = target.parent() unless target.hasClass("contact")
      @contacts.at(target.data("position"))

)
