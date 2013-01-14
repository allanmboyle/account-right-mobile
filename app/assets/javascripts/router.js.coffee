define([ "jquery", "backbone", "views/login", "views/customer_files" ], ($, Backbone, LoginView, CustomerFilesView) ->
  Backbone.Router.extend(
    initialize: () ->
      # Initialize pages to be displayed
      @loginView = new LoginView()
      @customerFilesView = new CustomerFilesView()
      # Tells Backbone to start watching for hashchange events
      Backbone.history.start()

    routes:
      "": "login"
      "login": "login"
      "customer_files": "customer_files"

    login: () ->
      @loginView.render()
      $.mobile.changePage("#login" , reverse: false, changeHash: true)

    customer_files: () ->
      @customerFilesView.show()

  )
)
