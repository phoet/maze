module Maze
  class EventSource
    attr_reader :count

    def initialize options = { count: 1000 }
      @count = options[:count].to_i
    end

    def emit_events
      TCPSocket.open DEFAULT_HOST, EVENT_SOURCE_PORT do |socket|
        count.times do |i|
          socket.puts "#{i + 1}|B"
          socket.flush
        end
      end
    end
  end
end
