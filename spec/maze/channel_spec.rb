require 'spec_helper'

module Maze
  describe Channel do
    let(:io) { FakeIO.new }
    let(:channel) { Channel.new io }
    let(:event_1) { Follow.new('1', 'F', '1', '2') }
    let(:event_2) { Follow.new('2', 'F', '1', '3') }
    let(:event_3) { Follow.new('3', 'F', '1', '4') }

    # context "sending" do
    #   it "bla" do
    #     e = Event.from_payload '2|B'
    #     channel.send_in_order e
    #     channel.queue.should have(1).elements
    #   end

    #   it "blupp" do
    #     e = Event.from_payload '1|B'
    #     channel.send_in_order e
    #     io.messages.should have(1).elements
    #   end

    #   it "flushes the queue" do
    #     channel.send_in_order event_1
    #     channel.queue.should be_empty
    #     io.messages.should have(1).elements
    #   end

    #   it "queues on changed order" do
    #     Channel.sequence = 1
    #     channel.send_in_order event_1
    #     channel.queue.should have(1).elements
    #     io.messages.should be_empty
    #   end

    #   it "orders the right way" do
    #     channel.send_in_order event_3
    #     channel.queue.should have(1).elements
    #     io.messages.should be_empty
    #     channel.send_in_order event_2
    #     channel.queue.should have(2).elements
    #     io.messages.should be_empty
    #     channel.send_in_order event_1
    #     channel.queue.should have(0).elements
    #     io.messages.should =~ [event_1, event_2, event_3].map(&:to_s)
    #   end
    # end

    # context "ordering" do
    #   it "returns true when its the first event" do
    #     channel.in_order?(event_1).should be_true
    #   end

    #   it "returns false for an invalid sequence" do
    #     Channel.sequence = 1
    #     channel.in_order?(event_1).should be_false
    #   end

    #   it "returns true for a valid sequence" do
    #     Channel.sequence = 1
    #     channel.in_order?(event_2).should be_true
    #   end
    # end
  end
end
