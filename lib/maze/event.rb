module Maze
  class Event
    PAYLOAD_SEPARATOR = '|'

    attr_reader :timestamp, :type, :from, :to

    def initialize *args
      @timestamp, @type, @from, @to = args
    end

    def self.inherited clazz
      event_classes << clazz
      super
    end

    def self.event_classes
      @@_event_classes ||= []
    end

    def self.from_payload payload
      data = payload.split PAYLOAD_SEPARATOR
      type = data[1]
      clazz = event_classes.find { |c| c.to_s.gsub('Maze::', '')[0] == type }
      clazz.new(*data)
    end
  end

  class Broadcast < Event; end
  class Follow < Event; end
  class Unfollow < Event; end
  class PrivateMsg < Event; end
  class StatusUpdate < Event; end
end
