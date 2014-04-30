module Maze
  class Channel
    attr_reader :io
    attr_accessor :sequence

    def initialize io
      @io = io
      @sequence = 0
    end

    def send event
      io.puts "#{event}"
      io.flush
    end

    def closed?
      io.closed?
    end
  end
end
