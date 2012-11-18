module Maze
  class Server
    attr_accessor :queue, :users
    attr_reader :endpoints, :iterator

    def initialize
      @queue      = []
      @users      = {}
      @endpoints  = []
      @iterator   = Iterator.new
    end

    def setup
      [UserEndpoint, EventEndpoint].each do |clazz|
        endpoint = clazz.new self
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
      iterator.add Event.from_payload payload
      while event = iterator.next
        Logger.log "consuming event #{event}"
        event.execute
        users.each do |user, channel|
          Logger.log "try notifying #{user} with #{event}"
          if event.notify_user? user
            Logger.log "notify #{user} with #{event}"
            channel.send event
          end
        end
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
        Logger.log "received user with ID: #{user}"
        server.users[user] = Channel.new io

        until io.closed?
          Logger.log "managing user #{user}"
          sleep 0.1
        end
      rescue
        Logger.log "error serving: #{$!}"
      end
    end

    class EventEndpoint < GServer
      attr_reader :server

      def initialize server
        super EVENT_SOURCE_PORT
        @server     = server
      end

      def serve io
        sleep 0.1 # allow users to connect before events are received
        while payload = io.readline.chomp
          Logger.log "received payload: #{payload}"
          server.notify payload
        end
      rescue
        Logger.log "error event serving: #{$!} #{$!.class}"
      end
    end
  end
end
