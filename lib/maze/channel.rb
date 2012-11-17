module Maze
  class Channel
    attr_reader :io
    attr_accessor :queue

    def initialize io
      @io       = io
      @queue    = []
    end

    def send_in_order event
      queue << event
      self.queue = queue.sort_by { |e| e.sequence }
      if in_order?(event)
        send queue
        self.class.sequence = queue.last.sequence
        queue.clear
      end
    end

    def in_order? event
      self.class.sequence + 1 == event.sequence
    end

    def send events
      events.each do |event|
        Logger.log "flushing the queue #{events}"
        io.puts "#{event}"
      end
    end

    def self.sequence
      @sequence ||= 0
    end

    def self.sequence= value
      @sequence = value
    end
  end
end
