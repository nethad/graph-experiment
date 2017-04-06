require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GraphExperiment
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    require 'neo4j/railtie'

    config.neo4j.session.options = {
        faraday_configurator: proc do |faraday|
          # The default configurator uses NetHttpPersistent, so if you override the configurator you must specify this
          faraday.use Faraday::Adapter::NetHttpPersistent
          # Optionally you can instead specify another adaptor
          # faraday.adapter :typhoeus

          # If you need to set options which would normally be the second argument of `Faraday.new`, you can do the following:
          faraday.options[:open_timeout] = 5
          faraday.options[:timeout] = 65
          # faraday.options[:ssl] = { verify: true }
        end
    }
  end
end
