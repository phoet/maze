require 'socket'

module Maze
  class Client
    def self.time
      TCPSocket.open 'localhost', EVENT_SOURCE_PORT do |socket|
        socket.read.chomp
      end
    end
  end
end
