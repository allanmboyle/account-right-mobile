define([ "backbone", "underscore" ], (Backbone, _) ->

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

    balanceDescription: () ->
      balance = @get("CurrentBalance")
      oweingEntity = if balance < 0 then "I" else "They"
      "#{oweingEntity} owe #{Math.abs(balance).toFixed(2)}"

    balanceClass: () ->
      if @get("CurrentBalance") < 0 then "negative" else "positive"

    phoneNumbers: () ->
      address = @_firstAddress()
      _.filter([address["Phone1"], address["Phone2"], address["Phone3"]], (phoneNumber) -> !!phoneNumber)

    emailAddress: () ->
      @_firstAddress()["Email"] || ""

    hasEmailAddress: () ->
      !_.isEmpty(@emailAddress())

    addressLines: () ->
      address = @_firstAddress()
      thirdLine = _.filter([address["State"], address["PostCode"], address["Country"]], (field) -> !!field).join(" ")
      _.filter([address["Street"], address["City"], thirdLine], (line) -> !!line)

    hasAddress: () ->
      !_.isEmpty(@addressLines())

    _firstAddress: () ->
      _.find(@get("Addresses"), (address) -> address["Index"] == 1) || {}

)
