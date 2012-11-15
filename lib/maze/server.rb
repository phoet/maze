require 'gserver'

module Maze
  class Server
    attr_accessor :queue, :users
    attr_reader :options
    attr_reader :endpoints

    def initialize options = { verbose: false }
      @options   = options
      @queue     = []
      @users     = {}
      @endpoints = []
    end

    def setup
      [EventEndpoint, UserEndpoint].each do |clazz|
        endpoint = clazz.new self
        endpoint.audit = !!options[:verbose]
        endpoints << endpoint
      end
    end

    def start
      endpoints.each do |endpoint|
        endpoint.start if endpoint.stopped?
      end
    end

    def stop
      endpoints.each do |endpoint|
        endpoint.stop unless endpoint.stopped?
      end
    end

    def notify(payload)
      event = Event.from_payload payload
      users.each do |user, channel|
        log "notify #{user} with #{payload}"
        if event.notify_user? user
          channel.push event
        end
      end
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
      user = io.readline.chomp
      server.log "received user with ID: #{user}"
      server.users[user] = Channel.new io

      until io.closed?
        server.log "managing user #{user}"
        sleep(0.1)
      end
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
        server.notify payload
      end
    end
  end

  class Channel
    attr_reader :io

    def initialize io
      @io = io
    end

    def push message
      io.print "#{message}\n"
      io.flush
    end
  end
end
