define([ "jquery", "backbone", "views/login", "views/customer_files" ], ($, Backbone, LoginView, CustomerFilesView) ->
  Backbone.Router.extend(

    initialize: () ->
      # Tells Backbone to start watching for hashchange events
      Backbone.history.start()

    routes:
      "": "login"
      "login": "login"
      "customer_files": "customer_files"

    login: () ->
      @loginView ?= new LoginView()
      @loginView.render()

    customer_files: () ->
      @customerFilesView ?= new CustomerFilesView()
      @customerFilesView.update()

  )
)
