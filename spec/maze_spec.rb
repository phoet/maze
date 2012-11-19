module Maze
  describe Maze do
    context "running client and server" do
      let(:server) { Server.new }
      let(:client) { Client.new '1' }

      let(:count) { 3 }
      let(:event_source_options) { { count: count, delay: 0 } }
      let(:event_source) { EventSource.new event_source_options }

      before do
        server.setup
        server.start
        sleep 0.1
      end

      after do
        server.stop
        sleep 0.1
      end

      it "emits payload queues it on the server" do
        server.iterator.sequence.should == 0
        event_source.emit_events

        sleep 1
        server.stop
        server.iterator.sequence.should == 3
      end

      it "notifies a connected user" do
        Thread.new do
          client.communicate do
            event_source.emit_events
          end
        end

        sleep 1
        client.should have(count).events
      end
    end
  end
end
