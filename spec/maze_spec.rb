require 'spec_helper'

describe Maze do
  context "running client and server" do
    let(:verbose) { true }
    let(:server) { Maze::Server.new(verbose: verbose) }
    let(:users) { 3.times.map { |id| Maze::Client.new(id) } }
    let(:event_source) { Maze::EventSource.new({ count: 3, delay: 0 }) }

    before(:all) do
      server.setup
    end

    before do
      server.start
    end

    after do
      server.stop
    end

    it "emits payload queues it on the server" do
      server.queue.should have(0).elements
      event_source.emit_events
      sleep(1)
      server.queue.should have(3).elements
    end

    it "accepts connected clients and stores their ids" do
      server.users.should have(0).elements
      users.map(&:communicate)
      sleep(1)
      server.users.keys.should =~ %w(0 1 2)
    end

    it "notifies the connected users" do
      users.map(&:communicate)
      event_source.emit_events
      puts 'moin'
      sleep(1)
      server.users.keys.should =~ %w(0 1 2)
    end
  end
end
