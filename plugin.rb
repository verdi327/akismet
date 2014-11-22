# install dependencies
gem "rakismet", "1.3.0"
gem 'httparty', '0.12.0' if ENV['NOTIFY_HIPCHAT']
gem 'hipchat', '1.1.0'   if ENV['NOTIFY_HIPCHAT']

# load the engine
load File.expand_path('../lib/akismet/engine.rb', __FILE__)

#configue api key and set site domain
Discourse::Application.config.rakismet.key = ENV["AKISMET_KEY"]
Discourse::Application.config.rakismet.url = Discourse.base_url

# Admin UI
register_asset "javascripts/discourse/templates/mod_queue_admin.js.handlebars"
register_asset "javascripts/admin/mod_queue.js", :admin
register_asset "javascripts/admin/mod_queue_admin.js", :admin

# UI
register_asset "stylesheets/mod_queue_styles.scss"

after_initialize do
  require_dependency File.expand_path('../app/models/discourse/post.rb', __FILE__)
  require_dependency File.expand_path('../app/models/discourse/topic.rb', __FILE__)
  require_dependency File.expand_path('../app/controllers/discourse/posts_controller.rb', __FILE__)
  require_dependency File.expand_path('../jobs/check_for_spam_posts.rb', __FILE__)
end

# And mount the engine
Discourse::Application.routes.append do
  mount Akismet::Engine, at: '/akismet'
end