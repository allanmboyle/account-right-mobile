define([ "backbone", "models/customer_file" ], (Backbone, CustomerFile) ->
  Backbone.Collection.extend(
    model: CustomerFile,

    url: "/customer_files",

    withExamples: () ->
      self = this
      _.each([ "First", "Second", "Third" ], (name) -> self.add(name : name))
      this

  )
)
