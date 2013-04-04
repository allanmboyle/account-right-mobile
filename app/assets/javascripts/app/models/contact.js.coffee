define([ "backbone" ], (Backbone) ->

  class Contact extends Backbone.Model

    defaults: {
      CoLastName: "Not specified"
      IsIndividual: "Not specified"
      FirstName: "Not specified"
      Type: "Not specified"
      CurrentBalance: "Not specified"
    }

    name: () ->
      if @get("IsIndividual") then "#{@get("CoLastName")}, #{@get("FirstName")}" else @get("CoLastName")

)
