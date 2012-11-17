module Maze
  VERSION = '0.0.8'

  DEFAULT_HOST      = 'localhost'
  EVENT_SOURCE_PORT = 9090
  USER_CLIENT_PORT  = 9099
end

require 'logger'
require 'socket'
require 'gserver'

require_relative 'maze/logger'
require_relative 'maze/event'
require_relative 'maze/channel'
require_relative 'maze/client'
require_relative 'maze/event_emitter'
require_relative 'maze/server'
