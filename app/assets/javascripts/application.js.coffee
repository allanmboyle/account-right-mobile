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
    "text" : "text-2.0.3",
   # Backbone application structure
    "router" : "router",
    # Models
    "models/customer_file": "models/customer_file",
    "models/customer_files": "models/customer_files",
    # Views
    "views/customer_files": "views/customer_files",
    "views/login": "views/login"

  # Sets the configuration for your third party scripts that are not AMD compatible
  shim:
    "backbone":
      "deps": [ "underscore", "jquery" ],
      "exports": "Backbone"  #attaches "Backbone" to the window object
)

require([ "jquery", "backbone", "router", "jquerymobile" ], ($, Backbone, AccountRightRouter) ->
  # Prevents all anchor click handling
  $.mobile.linkBindingEnabled = false;
  # Disabling this will prevent jQuery Mobile from handling hash changes
  $.mobile.hashListeningEnabled = false;
  # Instantiates a new Backbone.js Mobile Router
  @router = new AccountRightRouter()
)