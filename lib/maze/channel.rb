module Maze
  class Channel
    attr_reader :io
    attr_accessor :sequence

    def initialize io
      @io = io
      @sequence = 0
    end

    def send event
        io.write "#{event}\n"
        io.flush
    end
  end
end
