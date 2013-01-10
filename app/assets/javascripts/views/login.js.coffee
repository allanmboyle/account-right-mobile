define([ "backbone", "jquery", "underscore", "text!views/login.html" ], (Backbone, $, _, ViewHtml) ->
  Backbone.View.extend({
    initialize: () ->
      $("body").append(_.template(ViewHtml))
    }

    render: () ->
      $("#username").focus().trigger("refresh")
      this
  )
)
