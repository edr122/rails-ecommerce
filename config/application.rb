require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.api_only = true
    config.active_job.queue_adapter = :sidekiq
    config.eager_load_paths << Rails.root.join("app/lib")
  end
end
