define([ "jquery",
         "backbone",
         "./models/application_state"
         "./views/live_login",
         "./views/customer_files",
         "./views/contacts",
         "./views/contact_details"], ($, Backbone, ApplicationState, LiveLoginView,
                                      CustomerFilesView, ContactsView, ContactDetailsView) ->

  class AccountRightRouter extends Backbone.Router

    initialize: () ->
      @applicationState = new ApplicationState()
      Backbone.history.start() # Track hashchange events

    routes:
      "live_login": "liveLogin"
      "customer_files": "customerFiles"
      "contacts": "contacts"
      "contact_details": "contactDetails"
      "": "liveLogin"

    liveLogin: () ->
      @liveLoginView ?= new LiveLoginView()
      @liveLoginView.render()

    customerFiles: () ->
      @customerFilesView ?= new CustomerFilesView(@applicationState)
      @customerFilesView.update()

    contacts: () ->
      @contactsView ?= new ContactsView(@applicationState)
      @contactsView.update()

    contactDetails: () ->
      @contactDetailsView ?= new ContactDetailsView(@applicationState)
      @contactDetailsView.render()

)
