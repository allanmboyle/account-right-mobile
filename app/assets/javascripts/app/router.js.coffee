define([ "jquery",
         "backbone",
         "./views/live_login",
         "./views/customer_files",
         "./views/customer_file_login",
         "./views/contacts" ], ($, Backbone, LiveLoginView, CustomerFilesView, CustomerFileLoginView, ContactsView) ->

  class AccountRightRouter extends Backbone.Router

    initialize: () ->
      # Start tracking hashchange events
      Backbone.history.start()

    routes:
      "live_login": "live_login"
      "customer_files": "customer_files"
      "customer_file_login": "customer_file_login"
      "contacts": "contacts"
      "": "live_login"

    live_login: () ->
      @liveLoginView ?= new LiveLoginView()
      @liveLoginView.render()

    customer_files: () ->
      @customerFilesView ?= new CustomerFilesView()
      @customerFilesView.update()

    customer_file_login: () ->
      @customerFileLoginView ?= new CustomerFileLoginView()
      @customerFileLoginView.render()

    contacts: () ->
      @contactsView ?= new ContactsView()
      @contactsView.update()

)
