define([ "backbone", "./contact" ], (Backbone, Contact) ->

  class Contacts extends Backbone.Collection

    model: Contact

    url: "/contact"

    comparator: (contact) ->
      contact.get("CoLastName").toUpperCase()

)
