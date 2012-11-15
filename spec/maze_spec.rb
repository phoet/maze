require 'spec_helper'

describe Maze do
  context "running client and server" do
    let(:event_source) { Maze::EventSource.new({ count: 3, delay: 0 }) }
    let(:server) { Maze::Server.new }

    before do
      server.start
    end

    after do
      server.stop
    end

    it "emits events through the client and they are queued on the server" do
      server.queue.should have(0).elements
      event_source.emit_events
      sleep(1)
      server.queue.should have(3).elements
    end
  end
end
