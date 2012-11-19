module Maze
  describe User do
    let(:follower_id) { '2' }
    let(:user) { User.new '1' }

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
