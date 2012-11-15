require 'gserver'

module Maze
  class Server < GServer
    attr_reader :options

    def initialize options
      super EVENT_SOURCE_PORT
      self.audit = !!options[:verbose]
      @options = options
    end

    def serve io
      while payload = io.readline
        log "received payload: #{payload}"
        self.class.queue << payload
      end
    end

    def log message
      puts message if options[:verbose]
    end

    def self.queue
      @@_queue ||= []
    end

    def self.start options = { verbose: false }
      @server.stop if @server

      @server = Server.new options
      @server.start
    end

    def self.running?
      !@server.stopped?
    end

    def self.stop
      @server.shutdown if running?
    end
  end
end
