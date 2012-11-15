require 'spec_helper'

module Maze
  # | Payload      | Timestamp | Type         | From User Id | To User Id |
  # |--------------|-----------|--------------|--------------|------------|
  # |`666|F|60|50` | 666       | Follow       | 60           | 50         |
  # |`1|U|12|9`    | 1         | Unfollow     | 12           | 9          |
  # |`542532|B`    | 542532    | Broadcast    | -            | -          |
  # |`43|P|32|56`  | 43        | Private Msg  | 2            | 56         |
  # |`634|S|32`    | 634       | Status Update| 32           | -          |
  describe Event do
    context "setup" do
      it "tracks all event classes" do
        Event.event_classes.should have(5).elements
      end
    end
    context "handling the payload" do
      it "creates the right event from a given payload" do
        {
          '666|F|60|50' => Follow,
          '1|U|12|9'    => Unfollow,
          '542532|B'    => Broadcast,
          '43|P|32|56'  => PrivateMsg,
          '634|S|32'    => StatusUpdate,
        }.each do |payload, clazz|
          Event.from_payload(payload).should be_an_instance_of clazz
        end
      end

      let(:payload) { '666|F|60|50' }

      it "fills the right data for the payload" do
        Event.from_payload(payload).tap do |event|
          event.timestamp.should  == '666'
          event.type.should       == 'F'
          event.from.should       == '60'
          event.to.should         == '50'
        end
      end
    end
  end
end
