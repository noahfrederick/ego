require_relative 'capability'
require_relative 'handler'
require_relative 'robot_error'
require 'hooks'

module Ego
  class Robot
    include Hooks
    include Hooks::InstanceHooks

    attr_reader :name, :options, :capabilities
    attr_accessor :context

    alias_method :provide, :define_singleton_method

    define_hooks :on_ready, :on_shutdown

    def initialize(options)
      @name = options.robot_name
      @options = options
      @context = nil
      @capabilities = []
      @handlers = []
    end

    def ready
      run_hook :on_ready
      self
    end

    def shutdown
      run_hook :on_shutdown
    end

    def can(desc)
      unless @context
        raise RobotError, 'Cannot add capability outside of plug-in context'
      end
      @capabilities << Capability.new(desc, @context)
    end

    def on(condition, priority = 5, &action)
      unless action
        raise RobotError, "Hook requires an action: robot.on #{condition.inspect}"
      end

      if condition.respond_to?(:each_pair)
        # Condition is a hash of conditions and priorities
        condition.each_pair { |c, p| on(c, p, &action) }
      else
        # Register a new handler with condition
        @handlers << Handler.new(condition, action, priority)
      end
    end

    def run_action(action, params)
      instance_exec(params, &action)
    end

    def handle(query)
      @handlers.sort.reverse_each do |handler|
        if params = handler.handle(query)
          return run_action(handler.action, params)
        end
      end
    end
  end
end
