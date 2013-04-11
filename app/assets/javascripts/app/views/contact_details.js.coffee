define([ "backbone",
         "jquery",
         "underscore",
         "text!./contact_details.tmpl" ], (Backbone, $, _, Template) ->

  $("body").append("<div id='contact-details' data-role='page' data-title='Contact Details'></div>")

  class ContactsView extends Backbone.View

    initialize: (@applicationState) ->
      @compiledTemplate = _.template(Template)

    el: $("#contact-details")

    render: () ->
      @$el.html(@compiledTemplate(contact: @applicationState.openedContact))
      $.mobile.changePage("#contact-details", reverse: false, changeHash: false, transition: "slide")
      this

)
