define([ "backbone" ], (Backbone) ->

  class Contact extends Backbone.Model

    defaults: {
      name: "Not specified",
      type: "Not specified",
      balance: "Not specified"
    }

)
