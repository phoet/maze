require 'socket'

module Maze
  class Client
    attr_reader :id

    def initialize id
      @id = id
    end

    def communicate
      TCPSocket.open HOST, USER_CLIENT_PORT do |socket|
        # say hello
        socket.print "#{id}\n"
        socket.flush
        yield socket if block_given?
      end
    end
  end

  class EventSource
    attr_reader :count, :delay

    def initialize options = { count: 1000, delay: 0 }
      @count = options[:count].to_i
      @delay = options[:delay].to_i
    end

    def emit_events
      TCPSocket.open HOST, EVENT_SOURCE_PORT do |socket|
        count.times do |i|
          socket.print "#{i}|F|60|50\n"
          socket.flush
          if delay > 0
            sleep(delay)
          end
        end
      end
    end
  end
end
