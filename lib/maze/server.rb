require 'gserver'
require 'thread'

module Maze
  class Server
    attr_accessor :queue, :users, :sequence
    attr_reader :options # get rid of this
    attr_reader :endpoints

    def initialize options = { verbose: false }
      @options    = options
      @queue      = []
      @users      = {}
      @endpoints  = []
      @sequence   = 0
      @mutex = Mutex.new
    end

    def setup
      [UserEndpoint, EventEndpoint].each do |clazz|
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
      sleep 0.2
      Logger.log "i am thread #{Thread.current}"
      e = Event.from_payload payload
      # @mutex.synchronize do
        queue << e
        self.queue = queue.sort_by { |e| e.sequence }

        queue.each do |event|
          Logger.log "queue is #{queue}"
          return unless sequence + 1 == e.sequence
          event.execute
          users.each do |user, channel|
            Logger.log "try notifying #{user} with #{event}"
            if event.notify_user? user
              Logger.log "notify #{user} with #{event}"
              channel.send event
              Logger.log "notified #{user} with #{event}"
            end
          end
        end
        self.sequence = queue.last.sequence
        queue.clear
      # end
    rescue
      puts "error notiying: #{$!}"
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

      def log message
        Logger.log message
      end

      def serve io
        while payload = io.readline.chomp
          Logger.log "received payload: #{payload}"
          server.notify payload
        end
      rescue
        puts "error event serving: #{$!} #{$!.class}"
      end
    end
  end
end
