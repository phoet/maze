module Maze
  class Channel
    attr_reader :io
    attr_accessor :queue, :sequence

    def initialize io
      @io       = io
      @queue    = []
      @sequence = nil
    end

    def send_in_order event
      queue << event
      self.queue = queue.sort_by { |e| e.sequence }
      if in_order?(event)
        send queue
        self.sequence = queue.last.sequence
        queue.clear
      end
    end

    def in_order? event
      sequence.nil? || sequence + 1 == event.sequence
    end

    def send events
      events.each do |event|
        Logger.log "flushing the queue #{events}"
        io.puts "#{event}"
      end
    end
  end
end
