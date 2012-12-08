module Maze
  class Server
    attr_accessor :connections
    attr_reader :endpoints

    def initialize
      @connections = {}
      @endpoints   = []
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
        Logger.log "stopping endpoint #{endpoint}"
        endpoint.stop unless endpoint.stopped?
      end
    end

    def notify iterator
      while event = iterator.next
        Logger.log "consuming event #{event}"
        event.execute connections.keys
        connections.each do |user, channel|
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
        super USER_CLIENT_PORT, GServer::DEFAULT_HOST, MAX_CONNECTIONS
        @server = server
      end

      def serve io
        loop do
          id = io.readline.chomp
          user = User.new id
          Logger.log "received user with ID: #{user}"
          server.connections[user] = Channel.new io
        end
      rescue EOFError
        Logger.log "closed user stream"
      rescue
        Logger.log "error serving: #{$!} #{$!.class}"
      end
    end

    class EventEndpoint < GServer
      attr_reader :server, :iterator

      def initialize server
        super EVENT_SOURCE_PORT
        @server   = server
        @iterator = Iterator.new
      end

      def serve io
        loop do
          payload = io.readline.chomp
          Logger.log "received payload: #{payload}"
          iterator.add Event.from_payload payload
          server.notify iterator
        end
      rescue EOFError
        Logger.log "closed event stream"
        @iterator.reset
      rescue
        Logger.log "error event serving: #{$!} #{$!.class}"
      end
    end
  end
end
