module Maze
  class EventSource
    attr_reader :count, :delay

    def initialize options = { count: 1000, delay: 0 }
      @count = options[:count].to_i
      @delay = options[:delay].to_i
    end

    def emit_events
      TCPSocket.open DEFAULT_HOST, EVENT_SOURCE_PORT do |socket|
        count.times do |i|
          socket.puts "#{i + 1}|B"
          socket.flush
          if delay > 0
            sleep delay
          end
        end
      end
    end
  end
end
