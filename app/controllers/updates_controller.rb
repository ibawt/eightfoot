require 'server_side_events'

class UpdatesController < ApplicationController
  include ActionController::Live

  def index
    response.headers['Content-Type'] = 'text/event-stream'

    sse = ServerSideEvents::Stream.new response.stream
    sse.write(message: 'Connected!')

    begin
      loop do
        puts 'writing?'
        sleep 1
      end
    ensure
      sse.close
    end
  end
end
