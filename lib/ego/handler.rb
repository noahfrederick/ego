require_relative 'listener'
require_relative 'printer'

module Ego
  class Handler
    @@handlers = {}
    @@listeners = []

    attr_reader :name
    attr_accessor :description

    def initialize(name)
      @name = name
    end

    def to_s
      "#{@description}"
    end

    def listen(pattern, priority: 5, &parser)
      unless block_given?
        parser = Proc.new { |matches| matches }
      end
      @@listeners << Ego::Listener.new(pattern, priority, parser, @name)
    end

    def run(robot = nil, params = nil, &action)
      @action = action if block_given?
      return if robot.nil?

      robot.run_hook :before_run
      if @action.arity == 1
        @action.call(robot)
      else
        @action.call(robot, params)
      end
      robot.run_hook :after_run
    end

    def self.register(name = nil)
      if name.nil?
        path = caller_locations(1, 1)[0].absolute_path
        name = File.basename(path, '.*')
      end

      handler = Ego::Handler.new(name)
      yield handler

      @@handlers[handler.name] = handler
    end

    def self.has(name)
      @@handlers.has_key?(name)
    end

    def self.load(handlers)
      handlers.each do |path|
        name = File.basename(path, '.*')
        require path unless has(name)
      end
    end

    def self.dispatch(robot, query)
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
