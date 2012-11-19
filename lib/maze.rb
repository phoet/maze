module Maze
  VERSION = '0.0.11'

  DEFAULT_HOST      = 'localhost'
  EVENT_SOURCE_PORT = 9090
  USER_CLIENT_PORT  = 9099
end

require 'logger'
require 'socket'
require 'gserver'
require 'set'

require_relative 'maze/logger'
require_relative 'maze/iterator'
require_relative 'maze/user'
require_relative 'maze/event'
require_relative 'maze/channel'
require_relative 'maze/client'
require_relative 'maze/event_emitter'
require_relative 'maze/server'
