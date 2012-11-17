module Maze
  class Relation
    def self.add from, to
      relationships[from] << to
    end

    def self.remove from, to
      relationships[from].delete to
    end

    def self.subscribers user
      relationships[user].to_a
    end

    def self.relationships
      @relationships ||= Hash.new { |hash, key| hash[key] = Set.new }
    end

    def self.clear
      @relationships = nil
    end
  end
end