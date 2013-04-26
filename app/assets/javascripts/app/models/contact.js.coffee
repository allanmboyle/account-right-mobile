define([ "backbone", "underscore" ], (Backbone, _) ->

  class Contact extends Backbone.Model

    defaults: {
      CoLastName: ""
      IsIndividual: ""
      FirstName: ""
      Type: ""
      CurrentBalance: ""
    }

    name: () ->
      if @get("IsIndividual") then "#{@get("CoLastName")}, #{@get("FirstName")}" else @get("CoLastName")

    balanceDescription: () ->
      balance = @get("CurrentBalance")
      owingEntity = @_owingEntity()
      startingPhrase = if _.isEmpty(owingEntity) then "" else "#{owingEntity} owe "
      "#{startingPhrase}#{Math.abs(balance).toFixed(if balance == 0 then 0 else 2)}"

    balanceClass: () ->
      balance = @get("CurrentBalance")
      if balance < 0
        "negative"
      else if balance == 0
        "zero"
      else
        "positive"

    isOwing: () ->
      @get("CurrentBalance") > 0

    isOwed: () ->
      @get("CurrentBalance") < 0

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

    _owingEntity: () ->
      balance = @get("CurrentBalance")
      if balance < 0
        "I"
      else if balance == 0
        ""
      else
        "They"

)
