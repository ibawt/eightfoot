require File.expand_path('../boot', __FILE__)
require 'yajl/json_gem'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)


module Eightfoot
  class Application < Rails::Application
    config.encoding = "utf-8"
    #config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.cache_store = :dalli_store
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end

  def self.build_redis
    redis = Redis.new(:host => '127.0.0.1', :port => ENV['BOXEN_REDIS_PORT'] || 6379)
    Redis::Namespace.new(:eightfoot, redis: redis)
  end

  mattr_accessor :redis
  def self.redis=(value)
    @@redis = value
  end
end
