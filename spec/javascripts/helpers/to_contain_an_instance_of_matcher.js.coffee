beforeEach(() ->
  @addMatchers(
    toContainAnInstanceOf: (type) ->
      notText = if @isNot then " not" else ""
      @message = () -> "Expected #{JSON.stringify(@actual)}#{notText} to contain an element of type '#{type}'"
      matchingElements = (element for element in @actual when element instanceof type)
      matchingElements.length > 0
  )
)
