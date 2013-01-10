define([ "backbone", "jquery", "underscore", "text!views/login.html" ], function(Backbone, $, _, ViewHtml) {
    return Backbone.View.extend({
        initialize: function() {
            $("body").append(_.template(ViewHtml));
        },
        render: function() {
            $("#username").focus().trigger("refresh");
            return this;
        }
    });
});
