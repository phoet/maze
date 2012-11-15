module Maze
  VERSION = '0.0.3'

  HOST              = 'localhost'
  EVENT_SOURCE_PORT = 9090
  USER_CLIENT_PORT  = 9099
end

require 'maze/client'
require 'maze/server'
require 'maze/event'
