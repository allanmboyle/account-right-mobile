define([ "backbone",
         "jquery",
         "underscore",
         "../models/contacts",
         "text!./contacts_layout.tmpl",
         "text!./contacts_content.tmpl"], (Backbone, $, _, Contacts, LayoutTemplate, ContentTemplate) ->

  $("body").append("<div id='contacts' data-role='page' data-title='Contacts'></div>")

  class ContactsView extends Backbone.View

    initialize: () ->
      @compiledContentTemplate = _.template(ContentTemplate)
      @contacts = new Contacts().on("reset", @render, this)
      @$el.html(_.template(LayoutTemplate))
      @$el.bind("pagebeforeshow", () ->
        $("#contacts-list").listview(autodividers: true, autodividersSelector: (li) -> $(li).find(".name").text()[0])
        $("#contacts-list").listview("refresh")
      )

    el: $("#contacts")

    update: () ->
      @contacts.fetch()

    render: () ->
      $("#contacts-content").html(
        @compiledContentTemplate(contacts: @contacts, balanceDescription: @balanceDescription)
      )
      $.mobile.changePage("#contacts", reverse: false, changeHash: false)
      this

    balanceDescription: (contact) ->
      balance = contact.get("CurrentBalance")
      oweingEntity = if balance < 0 then "I" else "They"
      "#{oweingEntity} owe #{Math.abs(balance).toFixed(2)}"

)
