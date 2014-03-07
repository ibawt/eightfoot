require 'github_helper'
BetterErrors.editor = "emacs://open/?url=file://%{file}&line=%{line}" if defined? BetterErrors

memcache_port = ENV['BOXEN_MEMCACHED_PORT'] || 11211
unless Rails.env.test?
  stack = Faraday::RackBuilder.new do |builder|
    store  = ActiveSupport::Cache.lookup_store(:mem_cache_store,["localhost:#{memcache_port}"])
    builder.use Faraday::HttpCache, store: store , logger: Rails.logger, shared_cache: false, serializer: Yajl
    builder.use Octokit::Response::RaiseError
    builder.adapter Faraday.default_adapter
  end
  Octokit.middleware = stack
end
