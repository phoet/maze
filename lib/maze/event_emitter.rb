module Maze
  class EventSource
    attr_reader :count, :delay

    def initialize options = { count: 1000, delay: 0 }
      @count = options[:count].to_i
      @delay = options[:delay].to_i
    end

    def emit_events(type = 'F')
      TCPSocket.open DEFAULT_HOST, EVENT_SOURCE_PORT do |socket|
        count.times do |i|
          socket.print "#{i + 1}|#{type}|60|#{i}\n"
          socket.flush
          if delay > 0
            sleep(delay)
          end
        end
      end
    end
  end
end
