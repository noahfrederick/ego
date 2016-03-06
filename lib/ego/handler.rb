module Ego
  class Handler
    include Comparable

    @@handlers = {}

    attr_reader :name, :priority

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

      robot.debug self

      if @action.arity == 1
        @action.call(robot)
      else
        @action.call(robot, matches)
      end
    end

    def self.register handler
      @@handlers[handler.name] = handler
    end

    def self.has handler_name
      @@handlers.has_key? handler_name
    end

    def self.load handler_names
      handler_names.each do |path|
        handler = File.basename(path, '.*')
        require path unless has(handler)
      end
    end

    def self.dump
      @@handlers.keys.sort.each do |key|
        puts @@handlers[key]
      end
    end

    def self.dispatch robot, query
      @@handlers.values.sort.reverse_each do |handler|
        return if handler.handle robot, query
      end
    end
  end
end

def handle phrase, name: nil, priority: 5, &action
  handler_path = caller_locations(1, 1)[0].absolute_path
  handler_basename = File.basename(handler_path, '.*')
  name = [handler_basename, name].compact.join('.')
  handler = Ego::Handler.new(name, phrase, priority, action)

  Ego::Handler.register handler
end
