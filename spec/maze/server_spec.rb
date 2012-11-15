require 'spec_helper'

module Maze
  class FakeIO
    attr_reader :messages

    def initialize
      @messages = []
    end

    def print message
      messages << message
    end

    def flush; end
  end

  describe Server do

    let(:channel) { Channel.new FakeIO.new }
    let(:receiving_user) { '1' }
    let(:server) do
      server = Server.new
      server.users[receiving_user] = channel
      server
    end
    let(:event_for_user_1) { "43|P|32|#{receiving_user}" }

    context "notification" do
      it "notifies a user" do
        channel.io.messages.should be_empty
        server.notify event_for_user_1
        channel.io.messages.should have(1).elements
      end
    end
  end
end
