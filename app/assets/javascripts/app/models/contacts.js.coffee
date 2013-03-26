define([ "backbone", "./contact" ], (Backbone, Contact) ->

  class Contacts extends Backbone.Collection

    model: Contact

    url: "/contacts"

)
