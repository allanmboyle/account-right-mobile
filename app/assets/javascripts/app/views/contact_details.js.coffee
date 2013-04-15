define([ "jquery",
         "underscore",
         "./base_view",
         "text!./contact_details.tmpl" ], ($, _, BaseView, Template) ->

  $("body").append("<div id='contact-details' data-role='page' data-title='Contact Details'></div>")

  class ContactsView extends BaseView

    initialize: (@applicationState) ->
      @compiledTemplate = _.template(Template)

    el: $("#contact-details")

    render: () ->
      @$el.html(@compiledTemplate(header: @_headerContent(), contact: @applicationState.openedContact))
      $.mobile.changePage("#contact-details", reverse: false, changeHash: false, transition: "slide")
      this

    _headerContent: () ->
      customerFileName = @applicationState.openedCustomerFile.get("Name")
      @renderHeader(
        button: { href: "#contacts", label: "Back" },
        title: { elementClass: "customer-file-name", label: customerFileName }
      )

)
