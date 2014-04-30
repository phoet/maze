module Maze
  describe Maze do
    context "running client and server" do
      let(:server) { Server.new }
      let(:client) { Client.new '1' }

      let(:count) { 3 }
      let(:event_source_options) { { count: count } }
      let(:event_source) { EventSource.new event_source_options }

      before do
        server.setup
        server.start
      end

      after do
        server.stop
      end

      it "notifies a connected user" do
        Thread.new do
          client.communicate
        end
        Thread.new do
          event_source.emit_events
        end

        sleep 0.2
        client.should have(count).events
      end
    end
  end
end
