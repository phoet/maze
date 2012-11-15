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

    context "notification" do
      let(:any_user) { '-1' }
      let(:receiving_user) { '1' }
      let(:private_message_for_1) { PrivateMsg.new('666', 'P', '2', receiving_user) }
      let(:follow_for_1) { Follow.new('666', 'F', '2', receiving_user) }
      let(:unfollow_for_1) { Follow.new('666', 'U', '2', receiving_user) }
      let(:status_update_of_1) { StatusUpdate.new('666', 'S', receiving_user) }
      let(:broadcast) { Broadcast.new('666', 'B') }

      it "allows notification for private messages" do
        private_message_for_1.notify_user?(receiving_user).should be_true
        private_message_for_1.notify_user?(any_user).should be_false
      end

      it "allows notification for follows" do
        follow_for_1.notify_user?(receiving_user).should be_true
        follow_for_1.notify_user?(any_user).should be_false
      end

      it "allows notification for unfollows" do
        unfollow_for_1.notify_user?(receiving_user).should be_true
        unfollow_for_1.notify_user?(any_user).should be_false
      end

      it "denies notification for status updates" do
        status_update_of_1.notify_user?(receiving_user).should be_false
        status_update_of_1.notify_user?(any_user).should be_false
      end

      it "always allows notification for broadcasts" do
        broadcast.notify_user?(receiving_user).should be_true
        broadcast.notify_user?(any_user).should be_true
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
          event = Event.from_payload(payload)
          event.should be_an_instance_of clazz
          event.to_s.should == payload
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
