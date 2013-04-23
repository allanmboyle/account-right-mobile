define([ "jquery",
         "underscore",
         "./base/view",
         "./filters/require_live_login",
         "./filters/require_customer_file_login",
         "text!./contact_details.tmpl" ], ($, _, BaseView,
                                           RequireLiveLoginFilter, RequireCustomerFileLoginFilter,
                                           Template) ->

  $("body").append("<div id='contact-details' data-role='page' data-title='Contact details'></div>")

  class ContactsView extends BaseView

    initialize: (applicationState) ->
      super(applicationState, [ new RequireLiveLoginFilter(), new RequireCustomerFileLoginFilter() ])
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
