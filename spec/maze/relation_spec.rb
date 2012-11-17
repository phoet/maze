require 'spec_helper'

module Maze
  describe Relation do
    let(:from) { '1' }
    let(:to) { '2' }

    it "adds subscriptions" do
      Relation.add from, to
      Relation.relationships.should have(1).elements
      Relation.subscribers(to).should =~ [from]
    end

    it "removes subscriptions" do
      Relation.add 'a', to
      Relation.add 'b', to
      Relation.subscribers(to).should =~ ['a', 'b']
      Relation.remove 'b', to
      Relation.subscribers(to).should =~ ['a']
    end
  end
end
