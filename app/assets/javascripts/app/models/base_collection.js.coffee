define([ "backbone" ], (Backbone) ->

  class BaseCollection extends Backbone.Collection

    fetch: (options) ->
      self = this
      @fetchError = false
      super(_.extend({ error: () -> self.fetchError = true }, options))

)
