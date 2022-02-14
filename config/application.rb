require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsDevise
  class Application < Rails::Application

    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: false,
        request_specs: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end
    config.autoload_paths << Rails.root.join('lib')
    Rails.application.config.assets.precompile += %w( jquery-clockpicker.min.js )
    Rails.application.config.assets.precompile += %w( jquery-clockpicker.min.css )
    Rails.application.config.assets.precompile += %w( jquery.validate.min.js )
    Rails.application.config.assets.precompile += %w( parking_places.js )
    Rails.application.config.assets.precompile += %w( home_page.css )
    
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
