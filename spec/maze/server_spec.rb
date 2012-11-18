require 'spec_helper'

module Maze
  describe Server do
    let(:channel) { Channel.new FakeIO.new }
    let(:receiving_user) { '1' }
    let(:event_for_user_1) { "1|P|32|#{receiving_user}" }
    let(:server) do
      server = Server.new
      server.users[receiving_user] = channel
      server
    end

    context "notification" do
      it "notifies a user" do
        channel.io.messages.should be_empty
        server.notify event_for_user_1
        channel.io.messages.should have(1).elements
      end
    end
  end
end
