define([ "jquery", "backbone", "views/login" ], function($, Backbone, LoginView) {
    return Backbone.Router.extend({
        initialize: function() {
            // Initialize pages to be displayed
            this.loginView = new LoginView();

            // Tells Backbone to start watching for hashchange events
            Backbone.history.start();
        },
        routes: {
            "": "login"
        },
        login: function() {
            this.loginView.render();
            $.mobile.changePage("#login-page" , { reverse: false, changeHash: false });
        }
    });
});
