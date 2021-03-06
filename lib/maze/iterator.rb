module Maze
  class Iterator
    attr_accessor :events, :sequence

    def initialize
      reset
    end

    def add event
      self.events << event
      self.events = self.events.sort_by { |e| e.sequence }
      event
    end

    def next
      event = events.first
      if event && sequence + 1 == event.sequence
        self.sequence += 1
        events.delete event
        event
      end
    end

    def reset
      @events   = []
      @sequence = 0
    end
  end
end
