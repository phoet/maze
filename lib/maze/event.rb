module Maze
  class Event
    PAYLOAD_SEPARATOR = '|'

    attr_reader :timestamp, :type, :from, :to

    def initialize *args
      @timestamp, @type, @from, @to = args
    end

    def notify_user? user
      !to.nil? && user == to
    end

    def execute; end

    def sequence
      timestamp.to_i
    end

    def to_s
      [timestamp, type, from, to].compact.join PAYLOAD_SEPARATOR
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

  class Broadcast < Event
    def notify_user? user
      true
    end
  end

  class Follow < Event
    def execute
      Relation.add from, to
    end
  end

  class Unfollow < Event
    def notify_user? user
      false
    end
    def execute
      Relation.remove from, to
    end
  end

  class StatusUpdate < Event
    def notify_user? user
      Relation.subscribers(from).include? user
    end
  end

  class PrivateMsg < Event; end
end
