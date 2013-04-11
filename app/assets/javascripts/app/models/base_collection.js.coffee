define([ "backbone" ], (Backbone) ->

  class BaseCollection extends Backbone.Collection

    fetch: (options) ->
      @fetchError = false
      super(_.extend({ error: () => @fetchError = true }, options))

)
