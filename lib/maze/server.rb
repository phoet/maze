require 'gserver'

module Maze
  class Server
    attr_accessor :queue, :users
    attr_reader :options # get rid of this
    attr_reader :endpoints

    def initialize options = { verbose: false }
      @options    = options
      @queue      = []
      @users      = {}
      @endpoints  = []
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

    def notify payload
      Logger.log "notify with payload #{payload}"
      queue << payload

      event = Event.from_payload payload
      users.each do |user, channel|
        Logger.log "try notifying #{user} with #{event}"
        if event.notify_user? user
          Logger.log "notify #{user} with #{event}"
          channel.send_in_order event
        end
      end
    rescue
      puts "*" * 100
      puts $!
      puts "*" * 100
    end

    class UserEndpoint < GServer
      attr_reader :server

      def initialize server
        super USER_CLIENT_PORT
        @server = server
      end

      def log message
        Logger.log message
      end

      def serve io
        user = io.readline.chomp
        Logger.log "received user with ID: #{user}"
        server.users[user] = Channel.new io

        until io.closed?
          Logger.log "managing user #{user}"
          sleep 0.2
        end
      end
    end

    class EventEndpoint < GServer
      attr_reader :server

      def initialize server
        super EVENT_SOURCE_PORT
        @server = server
      end

      def log message
        Logger.log message
      end

      def serve io
        while payload = io.readline.chomp
          Logger.log "received payload: #{payload}"
          server.notify payload
        end
      end
    end
  end
end
