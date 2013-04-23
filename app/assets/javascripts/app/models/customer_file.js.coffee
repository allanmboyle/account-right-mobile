define([ "backbone" ], (Backbone) ->

  class CustomerFile extends Backbone.Model

    defaults: {
      Id: ""
      Name: ""
    }

    isEmpty: () ->
      iterator = (result, attributeValue) => result && _.isEmpty(attributeValue)
      _.reduce(@attributes, iterator, true)

)
