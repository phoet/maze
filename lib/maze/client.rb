require 'socket'

module Maze
  class Client
    attr_reader :id, :events

    def initialize id
      @id = id
      @events = []
    end

    def communicate
      puts "starting communication for #{id}"

      TCPSocket.open HOST, USER_CLIENT_PORT do |socket|
        # say hello
        socket.print "#{id}\n"

        yield if block_given?

        while payload = socket.readline.chomp
          puts "received event payload: #{payload}"
          events << Event.from_payload(payload)
          sleep(0.1)
        end
      end
    end
  end

  class EventSource
    attr_reader :count, :delay

    def initialize options = { count: 1000, delay: 0 }
      @count = options[:count].to_i
      @delay = options[:delay].to_i
    end

    def emit_events(type = 'F')
      TCPSocket.open HOST, EVENT_SOURCE_PORT do |socket|
        count.times do |i|
          socket.print "#{i}|#{type}|60|#{i}\n"
          socket.flush
          if delay > 0
            sleep(delay)
          end
        end
      end
    end
  end
end
