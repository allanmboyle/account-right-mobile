define([ "jquery",
         "underscore",
         "./base/view",
         "./filters/live_login_required",
         "text!./contact_details.tmpl" ], ($, _, BaseView, LiveLoginRequiredFilter, Template) ->

  $("body").append("<div id='contact-details' data-role='page' data-title='Contact details'></div>")

  class ContactsView extends BaseView

    initialize: (applicationState) ->
      super(applicationState, [ new LiveLoginRequiredFilter() ])
      @compiledTemplate = _.template(Template)

    el: $("#contact-details")

    liveLoginRequired: true

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
