define([ "backbone", "jquery", "underscore", "text!./login.tmpl" ], (Backbone, $, _, Template) ->

  $("body").append("<div id='customer_file_login' data-role='page' data-title='Customer File Login'></div>")
  $("#customer_file_login").on("pageshow", () -> $("#customer_file_username").focus())

  class CustomerFileLoginView extends Backbone.View

    initialize: () ->
      @$el.html(_.template(Template, title : "Customer File Login", type : "customer_file"))

    el: $("#customer_file_login")

    events: () ->
      "click #customer_file_login_submit": "login"

    login: (event) ->
      location.hash = "contacts"
      event.preventDefault()

    render: () ->
      $.mobile.changePage("#customer_file_login" , reverse: false, changeHash: false)
      this

)
