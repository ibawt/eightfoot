require 'github_helper'
BetterErrors.editor = "emacs://open/?url=file://%{file}&line=%{line}" if defined? BetterErrors
stack = Faraday::RackBuilder.new do |builder|
  builder.use Faraday::HttpCache, store: Rails.cache
  builder.use Octokit::Response::RaiseError
  builder.adapter Faraday.default_adapter
end
Octokit.middleware = stack
