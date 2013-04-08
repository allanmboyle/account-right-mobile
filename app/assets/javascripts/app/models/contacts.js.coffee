define([ "./base_collection", "./contact" ], (BaseCollection, Contact) ->

  class Contacts extends BaseCollection

    model: Contact

    url: "/contact"

    comparator: (contact) ->
      contact.get("CoLastName").toUpperCase()

)
