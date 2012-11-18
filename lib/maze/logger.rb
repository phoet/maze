module Maze
  class Logger
    def self.log message, level = :debug
      logger.send level, message
    end

    def self.logger
      @logger ||= ::Logger.new log_filename
    end

    def self.log_filename
      current_dir = File.dirname __FILE__
      File.join current_dir, '../../log/maze.log'
    end
  end
end
