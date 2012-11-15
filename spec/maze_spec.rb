require 'spec_helper'

describe Maze do
  context "running client and server" do
    before do
      Maze::Server.start
    end

    after do
      Maze::Server.stop
    end

    it "emits events through the client and they are queued on the server" do
      Maze::Server.queue.should have(0).elements
      Maze::EventSource.new({ count: 3, delay: 0 }).emit_events
      sleep(1)
      Maze::Server.queue.should have(3).elements
    end
  end
end
