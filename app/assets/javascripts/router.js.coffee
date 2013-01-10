define([ "jquery", "backbone", "/assets/views/login.js" ], ($, Backbone, LoginView) ->
  Backbone.Router.extend(
    initialize: () ->
      # Initialize pages to be displayed
      this.loginView = new LoginView()
      # Tells Backbone to start watching for hashchange events
      Backbone.history.start()

    routes:
      "": "login"

    login: () ->
      this.loginView.render()
      $.mobile.changePage("#login-page" , reverse: false, changeHash: false)
  )
)
