###
  This is a manifest file that'll be compiled into application.js, which will include all the files
  listed below.

  Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
  or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.

  It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
  the compiled file.

  WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
  GO AFTER THE REQUIRES BELOW.
###

require.config(
  # Script aliases
  paths:
    # Core Libraries
    "jquery": "jquery-1.8.3.min",
    "jquerymobile": "jquery.mobile-1.2.0.min",
    "underscore": "lodash-0.10.0.min",
    "backbone": "backbone-0.9.9.min",
    "text" : "text-2.0.3"

  # Sets the configuration for your third party scripts that are not AMD compatible
  shim:
    "backbone":
      "deps": [ "underscore", "jquery" ],
      "exports": "Backbone"  #attaches "Backbone" to the window object
)

require([ "require", "backbone", "jquery", "underscore", ], (require, Backbone, $, _) ->
  # Set up the "mobileinit" handler before requiring jQuery Mobile's module
  $(document).on("mobileinit",
    () ->
      # Disable jQuery Mobile Navigation
      $.mobile.ajaxEnabled = false
      $.mobile.linkBindingEnabled = false
      $.mobile.hashListeningEnabled = false
      $.mobile.pushStateEnabled = false
  )
  require([ "router", "jquerymobile" ], (AccountRightRouter) -> @router = new AccountRightRouter())
)
