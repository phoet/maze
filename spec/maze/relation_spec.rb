require 'spec_helper'

module Maze
  describe Relation do

    before do
      Relation.clear
    end

    let(:from) { '1' }
    let(:to) { '2' }

    it "adds subscriptions" do
      Relation.add from, to
      Relation.relationships.should have(1).elements
      Relation.subscribers(from).should =~ [to]
    end

    it "removes subscriptions" do
      Relation.add from, 'a'
      Relation.add from, 'b'
      Relation.subscribers(from).should =~ ['a', 'b']
      Relation.remove from, 'b'
      Relation.subscribers(from).should =~ ['a']
    end
  end
end
