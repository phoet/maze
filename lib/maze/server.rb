require 'gserver'

module Maze
  class Server
    attr_accessor :queue, :users
    attr_reader :options
    attr_reader :event_endpoint, :user_endpoint

    def initialize options = { verbose: false }
      @options = options
      @queue   = []
      @users   = {}

      @event_endpoint = EventEndpoint.new self
      @event_endpoint.audit = !!options[:verbose]

      @user_endpoint = UserEndpoint.new self
      @user_endpoint.audit = !!options[:verbose]
    end

    def start
      event_endpoint.start
      user_endpoint.start
    end

    def stop
      event_endpoint.stop
      user_endpoint.stop
    end

    def log message
      puts message if options[:verbose]
    end
  end

  class UserEndpoint < GServer
    attr_reader :server

    def initialize server
      super USER_CLIENT_PORT
      @server = server
    end

    def serve io
      user_id = io.readline.chomp
      server.log "received user with ID: #{user_id}"
      server.users[user_id] = io
    end
  end

  class EventEndpoint < GServer
    attr_reader :server

    def initialize server
      super EVENT_SOURCE_PORT
      @server = server
    end

    def serve io
      while payload = io.readline.chomp
        server.log "received payload: #{payload}"
        server.queue << payload
      end
    end
  end
end
