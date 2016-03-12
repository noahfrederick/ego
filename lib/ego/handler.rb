require_relative 'listener'
require_relative 'formatter'

module Ego
  class Handler
    @@handlers = {}
    @@listeners = []

    attr_reader :name
    attr_accessor :description

    def initialize name
      @name = name
    end

    def to_s
      "#{@description}"
    end

    def listen pattern, priority: 5, &parser
      unless block_given?
        parser = Proc.new { |matches| matches }
      end
      @@listeners << Ego::Listener.new(pattern, priority, parser, @name)
    end

    def run robot = nil, params = nil, &action
      if block_given?
        @action = action
      end

      if robot.nil?
        return
      elsif @action.arity == 1
        @action.call(robot)
      else
        @action.call(robot, params)
      end
    end

    def self.register name: nil
      if name.nil?
        handler_path = caller_locations(1, 1)[0].absolute_path
        name = File.basename(handler_path, '.*')
      end

      handler = Ego::Handler.new(name)
      yield handler

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

    def self.dispatch robot, query
      @@listeners.sort.reverse_each do |listener|
        if params = listener.match(query)
          return @@handlers[listener.handler].run(robot, params)
        end
      end
    end

    def self.handlers
      @@handlers
    end
  end
end
