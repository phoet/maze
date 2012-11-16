require 'spec_helper'

describe Maze do
  context "running client and server" do
    let(:server) { Maze::Server.new }
    let(:user_id) { 0 }
    let(:user) { Maze::Client.new user_id }
    let(:event_source_options) { { count: 3, delay: 0 } }
    let(:event_source) { Maze::EventSource.new event_source_options }

    before(:all) do
      server.setup
    end

    before do
      server.users.clear
      server.queue.clear
      server.start
      sleep 0.1
    end

    after do
      server.stop
      sleep 0.1
    end

    it "emits payload queues it on the server" do
      server.queue.should have(0).elements
      event_source.emit_events

      sleep 1
      server.stop
      server.queue.should have(3).elements
    end

    it "notifies a connected user" do
      Thread.new do
        user.communicate do
          event_source.emit_events
        end
      end

      sleep 1
      user.events.should have(1).elements
    end
  end
end
