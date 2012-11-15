require 'socket'

module Maze
  class Client
    def self.emit_events(options = { count: 1000, delay: 0 })
      TCPSocket.open HOST, EVENT_SOURCE_PORT do |socket|
        count = options[:count].to_i
        count.times do |i|
          socket.print "#{i}|F|60|50\n"
          socket.flush
          if (delay = options[:delay].to_i) > 0
            sleep(delay)
          end
        end
      end
    end
  end
end
