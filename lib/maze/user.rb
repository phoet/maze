module Maze
  class User
    attr_reader :id, :followers

    def initialize id
      @id = id
      @followers = Set.new
    end

    def add_follower id
      followers << id
    end

    def remove_follower id
      followers.delete id
    end

    def has_follower? id
      followers.include? id
    end

    def to_s
      "#{id}"
    end
  end
end
