require 'spec_helper'

module Maze
  describe Iterator do
    context "next" do
      let(:iterator) { Iterator.new }
      let(:event) { Event.from_payload '1|B' }

      it "has nothing when empty" do
        iterator.next.should be_nil
      end

      it "has a next when set" do
        iterator.add event
        iterator.next.should be event
      end

      it "handles a sequence of events" do
        events = 10.times.map do |i|
          iterator.add Event.from_payload "#{i + 1}|B"
        end

        events.each do |e|
          iterator.next.should be e
        end
      end

      it "handles an arbitrary sequence of events" do
        3.times do |i|
          iterator.add Event.from_payload "#{i + 1}|B"
        end

        12.times do
          iterator.next
        end

        iterator.add Event.from_payload "4|B"
        iterator.next.sequence.should == 4

        iterator.add Event.from_payload "8|B"
        iterator.add Event.from_payload "5|B"
        iterator.next.sequence.should == 5

        iterator.next.should be_nil
      end

      it "handles random event order" do
        events = 10.times.map { |i| Event.from_payload "#{i + 1}|B" }.shuffle
        events.each do |event|
          iterator.add event
        end

        10.times do |i|
          iterator.next.sequence.should == i + 1
        end
      end
    end
  end
end
