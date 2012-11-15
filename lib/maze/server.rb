require 'gserver'

module Maze
  class Server < GServer
    def initialize
      super EVENT_SOURCE_PORT
    end

    def serve io
      io.puts now
    end

    def now
      Time.now.to_s
    end

    def self.start options = { verbose: false }
      @server = Server.new
      @server.audit = !!options[:verbose]
      @server.start
    end

    def self.running?
      !@server.stopped?
    end

    def self.stop
      @server.shutdown
    end
  end
end
