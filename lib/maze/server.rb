require 'gserver'

module Maze
  class Server
    attr_accessor :queue
    attr_reader :options, :event_endpoint

    def initialize options = { verbose: false }
      @options = options
      @queue   = []

      @event_endpoint = EventEndpoint.new self
      @event_endpoint.audit = !!options[:verbose]
    end

    def start
      event_endpoint.start
    end

    def stop
      event_endpoint.shutdown
    end

    def log message
      puts message if options[:verbose]
    end
  end

  class EventEndpoint < GServer
    attr_reader :server

    def initialize server
      super EVENT_SOURCE_PORT
      @server = server
    end

    def serve io
      while payload = io.readline
        server.log "received payload: #{payload}"
        server.queue << payload
      end
    end
  end
end
