define([ "backbone",
         "jquery",
         "underscore",
         "../models/contacts",
         "text!./contacts.tmpl" ], (Backbone, $, _, Contacts, Template) ->

  $("body").append("<div id='contacts' data-role='page' data-title='Contacts'></div>")
  $("#contacts").bind("pagebeforeshow", () ->
    $("#contacts_list").listview(autodividers: true, autodividersSelector: (li) -> $(li).find(".name").text()[0])
    $("#contacts_list").listview("refresh")
  )

  class ContactsView extends Backbone.View

    initialize: () ->
      @compiledTemplate = _.template(Template)
      @contacts = new Contacts()
      @contacts.on("reset", @render, this)

    el: $("#contacts")

    update: () ->
      @contacts.fetch()

    render: () ->
      $("#contacts").html(@compiledTemplate(contacts: @contacts, balanceDescription: @balanceDescription))
      $.mobile.changePage("#contacts", reverse: false, changeHash: false)
      this

    balanceDescription: (contact) ->
      balance = contact.get('balance')
      oweingEntity = if balance < 0 then "I" else "They"
      amount = if balance < 0 then balance * -1 else balance
      "#{oweingEntity} owe #{amount}"

)
