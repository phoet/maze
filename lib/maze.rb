module Maze
  VERSION = '0.0.7'

  HOST              = 'localhost'
  EVENT_SOURCE_PORT = 9090
  USER_CLIENT_PORT  = 9099
end

require_relative 'maze/client'
require_relative 'maze/server'
require_relative 'maze/event'
