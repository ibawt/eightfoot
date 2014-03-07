redis_port = ENV['BOXEN_REDIS_PORT'] || 6379
sidekiq_config = { url: "redis://localhost:#{redis_port}", namespace: "eightfoot-workers" }

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end
