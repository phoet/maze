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
      let(:any_user)        { User.new '-1' }
      let(:receiving_user)  { User.new '1' }
      let(:sending_user)    { User.new '2' }

      let(:private_message_for_1) { PrivateMsg.new('666', 'P', sending_user.id, receiving_user.id) }
      let(:follow_for_1)          { Follow.new('666', 'F', sending_user.id, receiving_user.id) }
      let(:unfollow_for_1)        { Unfollow.new('666', 'U', sending_user.id, receiving_user.id) }
      let(:status_update_of_1)    { StatusUpdate.new('666', 'S', sending_user.id) }
      let(:broadcast)             { Broadcast.new('666', 'B') }

      it "allows notification for private messages" do
        private_message_for_1.notify_user?(receiving_user).should be_true
        private_message_for_1.notify_user?(any_user).should be_false
      end

      it "allows notification for follows" do
        follow_for_1.notify_user?(sending_user).should be_false
        follow_for_1.notify_user?(receiving_user).should be_true
        follow_for_1.notify_user?(any_user).should be_false
      end

      it "allows notification for unfollows" do
        unfollow_for_1.notify_user?(receiving_user).should be_false
        unfollow_for_1.notify_user?(any_user).should be_false
      end

      it "allows notification for status updates on followers" do
        receiving_user.add_follower sending_user.id
        status_update_of_1.notify_user?(receiving_user).should be_true
        status_update_of_1.notify_user?(any_user).should be_false
      end

      it "always allows notification for broadcasts" do
        broadcast.notify_user?(receiving_user).should be_true
        broadcast.notify_user?(any_user).should be_true
      end

      context "regression testing" do
        let(:payloads) do
          [
            '316|S|46',
            '317|F|46|68',
            '318|S|46',
            '319|U|46|68',
            '320|S|46',
            '321|F|46|68',
            '322|F|46|3',
            '323|S|46',
            '324|S|46',
            '325|P|46|68',
            '326|F|46|33',
            '327|U|46|68',
            '328|B'
          ]
        end
        let(:user) { User.new '33' }

        it "handles a chunk of notifation data correctly" do
          result = payloads.map do |payload|
            event = Event.from_payload payload
            event.execute [user]
            "#{event.notify_user? user} #{payload}"
          end
          # Problem with user 33: Expected:326|F|46|33 Found:328|B
          result.should include 'true 326|F|46|33'
        end
      end
    end

    context "following" do
      let(:any_user) { User.new '1' }
      let(:follower) { User.new '2' }
      let(:users)    { [any_user, follower] }

      let(:follow)   { Follow.new '1', 'F', any_user.to_s, follower.to_s }
      let(:status)   { StatusUpdate.new '2', 'S', follower.to_s }
      let(:unfollow) { Unfollow.new '3', 'U', any_user.to_s, follower.to_s }

      it "executes follow notifications and notifies accordingly" do
        status.notify_user?(any_user).should be_false
        follow.execute users
        status.notify_user?(any_user).should be_true
        unfollow.execute users
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
          '11|U|1|4',
        ].each do |p|
          e = Event.from_payload p
          e.execute users
        end
        any_user.followers.to_a.should =~ ["2", "3"]
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
