require 'spec_helper'

describe Maze do
  context "running client and server" do
    let(:now) { "2012-11-15 09:41:11 +0100" }

    before do
      Maze::Server.any_instance.stub(:now) { now }
      Maze::Server.start
    end

    after do
      Maze::Server.stop
    end

    it "connecting through a TCPSocket to the Server to get the current Time" do
      Maze::Client.time.should == now
    end
  end
end
