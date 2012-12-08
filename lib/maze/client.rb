module Maze
  class Client
    attr_reader :id, :events

    def initialize id
      @id = id
      @events = []
    end

    def communicate
      Logger.log "starting communication for #{id}"
      TCPSocket.open DEFAULT_HOST, USER_CLIENT_PORT do |socket|
        socket.print "#{id}\n"
        loop do
          payload = socket.readline.chomp
          Logger.log "received event payload: #{payload}"
          events << Event.from_payload(payload)
        end
      end
    rescue EOFError
      Logger.log "closed communication for #{id}"
    end
  end
end
