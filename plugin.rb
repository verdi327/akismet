# install dependencies
gem "rakismet", "1.3.0"

# load the engine
load File.expand_path('../lib/akismet/engine.rb', __FILE__)

#configue api keys
Discourse::Application.config.rakismet.key = "297ac5baa823"
Discourse::Application.config.rakismet.url = Rails.env.development? ? "http://localhost" : "http://discuss.newrelic.com"

after_initialize do
  require_dependency File.expand_path('../integrate.rb', __FILE__)
end