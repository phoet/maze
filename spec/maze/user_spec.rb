require 'spec_helper'

module Maze
  describe User do
    let(:user_id) { '1' }
    let(:follower_id) { '2' }
    let(:user) { User.new user_id }

    it "adds subscriptions" do
      user.add_follower follower_id
      user.should have(1).followers
    end

    it "removes subscriptions" do
      user.add_follower 'a'
      user.add_follower 'b'
      user.followers.to_a.should =~ ['a', 'b']

      user.remove_follower 'b'
      user.followers.to_a.should =~ ['a']
    end
  end
end
