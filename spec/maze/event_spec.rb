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
      let(:sending_user) { '2' }
      let(:private_message_for_1) { PrivateMsg.new('666', 'P', sending_user, receiving_user) }
      let(:follow_for_1) { Follow.new('666', 'F', sending_user, receiving_user) }
      let(:unfollow_for_1) { Unfollow.new('666', 'U', sending_user, receiving_user) }
      let(:status_update_of_1) { StatusUpdate.new('666', 'S', sending_user) }
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
        unfollow_for_1.notify_user?(receiving_user).should be_false
        unfollow_for_1.notify_user?(any_user).should be_false
      end

      it "denies notification for status updates" do
        Relation.add receiving_user, sending_user
        status_update_of_1.notify_user?(receiving_user).should be_true
        status_update_of_1.notify_user?(any_user).should be_false
      end

      it "always allows notification for broadcasts" do
        broadcast.notify_user?(receiving_user).should be_true
        broadcast.notify_user?(any_user).should be_true
      end
    end

    context "following" do
      let(:any_user) { '1' }
      let(:follower) { '2' }
      let(:follow)   { Follow.new '1', 'F', any_user, follower }
      let(:status)   { StatusUpdate.new '2', 'S', follower }
      let(:unfollow) { Unfollow.new '3', 'U', any_user, follower }

      it "executes follow notifications and notifies accordingly" do
        status.notify_user?(any_user).should be_false
        follow.execute
        status.notify_user?(any_user).should be_true
        unfollow.execute
        status.notify_user?(any_user).should be_false
      end

      it "handles a sequence of events" do
        [
          '1|B',
          '2|B',
          '3|S|1',
          '4|S|1',
          '5|F|1|2',
          '6|P|1|2',
          '7|F|1|3',
          '8|S|1',
          '9|F|1|4',
          '10|B',
        ].each do |p|
          e = Event.from_payload p
          e.execute
        end
        Relation.subscribers('1').should == []
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
