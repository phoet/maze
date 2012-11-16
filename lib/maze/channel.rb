module Maze
  class Channel
    attr_reader :io

    def initialize io
      @io = io
    end

    def push message
      io.puts "#{message}"
    end
  end
end
