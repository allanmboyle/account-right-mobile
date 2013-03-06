define([ "jquery",
         "backbone",
         "./views/live_login",
         "./views/customer_files",
         "./views/contacts" ], ($, Backbone, LiveLoginView, CustomerFilesView, ContactsView) ->

  class AccountRightRouter extends Backbone.Router

    initialize: () ->
      # Start tracking hashchange events
      Backbone.history.start()

    routes:
      "live_login": "live_login"
      "customer_files": "customer_files"
      "contacts": "contacts"
      "": "live_login"

    live_login: () ->
      @liveLoginView ?= new LiveLoginView()
      @liveLoginView.render()

    customer_files: () ->
      @customerFilesView ?= new CustomerFilesView()
      @customerFilesView.update()

    contacts: () ->
      @contactsView ?= new ContactsView()
      @contactsView.update()

)
