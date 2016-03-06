require_relative 'robot'

module Ego
  class Handler
    include Comparable

    @@handlers = []

    attr_reader :priority

    def initialize name, phrase, priority, action
      @name = name
      @phrase = phrase
      @priority = priority
      @action = action
    end

    def <=> other
      @priority <=> other.priority
    end

    def to_s
      "#{@name} handler (priority = #{@priority})"
    end

    def handle robot, query
      return false unless query.match(@phrase)
      @action.call(robot)
    end

    def self.register handler
      @@handlers << handler
    end

    def self.dispatch robot, query
      @@handlers.sort.reverse_each do |handler|
        return if handler.handle robot, query
      end
    end
  end
end

def handle phrase, name: nil, priority: 5, &action
  handler = Ego::Handler.new(name, phrase, priority, action)
  Ego::Handler.register handler
end
