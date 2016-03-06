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
      return false unless matches = query.match(@phrase)

      puts self if robot.options.verbose

      if @action.arity == 1
        @action.call(robot)
      else
        @action.call(robot, matches)
      end
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
  handler_path = caller_locations(1, 1)[0].absolute_path
  name = File.basename(handler_path, '.*') if name.nil?
  handler = Ego::Handler.new(name, phrase, priority, action)

  Ego::Handler.register handler
end
