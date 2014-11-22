Discourse.ModQueue = Discourse.Model.extend({
  confirmSpam: function() {
    return Discourse.ajax("/akismet/admin/confirm_spam", {
      type: "POST",
      data: {
        post_id: this.get("id")
      }
    });
  },

  allow: function() {
    return Discourse.ajax("/akismet/admin/allow", {
      type: "POST",
      data: {
        post_id: this.get("id")
      }
    });
  },

  deleteUser: function() {
    return Discourse.ajax("/akismet/admin/delete_user", {
      type: "DELETE",
      data: {
        user_id: this.get("user_id"),
        post_id: this.get("id")
      }
    });
  }
});

Discourse.ModQueue.reopenClass({
  findAll: function() {
    return Discourse.ajax("/akismet/admin.json")
    .then(function(posts) {
      return posts.map(function(post) {
        return Discourse.ModQueue.create(post);
      });
    });
  }
});