/* global confirm */
if (!Discourse.AdminTemplatesAdminView) Discourse.AdminTemplatesAdminView = Discourse.View.extend({});

Discourse.AdminTemplatesAdminView.reopen({
  insertAkismetitemView: function() {
    $(".nav").append('<li><a href="/akismet/admin">Akismet</a></li>');
  }.on("didInsertElement")
});

Discourse.AkismetRoute = Discourse.AdminRoute.extend({
 // this is just an empty admin route so that we are shown under the menu, too
});

Discourse.AkismetAdminController = Ember.ArrayController.extend({
  sortProperties: ["id"],
  sortAscending: true,

  actions: {
    confirmSpamPost: function(cur_model){
      cur_model.confirmSpam().then(function(result){
        bootbox.alert(result.msg);
        this.removeObject(cur_model);
      }.bind(this));
    },

    allowPost: function(cur_model){
      cur_model.allow().then(function(result){
        bootbox.alert(result.msg);
        this.removeObject(cur_model);
      }.bind(this));
    },

    deleteUser: function(cur_model){
      var that = this;
      var msg = "Are you sure you want to delete " + cur_model.get("username") + "?  This will remove all of their posts and topics and block their email and ip address."
      bootbox.confirm(msg, function(result) {
        if (result === true) {
          cur_model.deleteUser().then(function(result){
            bootbox.alert(result.msg);
            that.removeObject(cur_model);
          }.bind(this));
        }
      })
    },
  }
});


Discourse.AkismetAdminRoute = Discourse.Route.extend({
  model: function() {
    return Discourse.ModQueue.findAll();
  },

  renderTemplate: function() {
    this.render("mod_queue_admin");
  }
});

Discourse.Route.buildRoutes(function() {
  this.resource('akismet', function (){
    this.route("admin");
  });
});
