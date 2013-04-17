define([ "jquery",
         "underscore",
         "./base_view",
         "text!./contact_details.tmpl" ], ($, _, BaseView, Template) ->

  $("body").append("<div id='contact-details' data-role='page' data-title='Contact details'></div>")

  class ContactsView extends BaseView

    initialize: (@applicationState) ->
      @compiledTemplate = _.template(Template)

    el: $("#contact-details")

    renderOptions: { transition: "slide" }

    prepareDom: () ->
      @$el.html(@compiledTemplate(header: @_headerContent(), contact: @applicationState.openedContact))

    _headerContent: () ->
      customerFileName = @applicationState.openedCustomerFile.get("Name")
      @renderHeader(
        button: { elementId: "contacts-back", href: "#contacts", label: "Back" },
        title: { elementClass: "customer-file-name", label: customerFileName }
      )

)
