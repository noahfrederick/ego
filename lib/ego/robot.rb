require_relative 'capability'
require_relative 'handler'
require_relative 'robot_error'
require 'hooks'

module Ego
  # The robot instance provides a DSL for plug-ins to use to implement new
  # functionality and also share that functionality with other plug-ins.
  #
  # Much built-in functionality of Ego is also implemented using the plug-in
  # DSL.
  #
  # @see Ego.plugin
  class Robot
    include Hooks
    include Hooks::InstanceHooks

    attr_reader :name, :options, :capabilities

    alias_method :provide, :define_singleton_method

    define_hooks :on_ready, :on_shutdown
    define_hooks :before_handle_query, :after_handle_query, :on_unhandled_query
    define_hooks :before_action, :after_action

    # @param options [Options] the options to create a robot with
    #
    # @see Options
    def initialize(options)
      @name = options.robot_name
      @options = options
      @capabilities = []
      @handlers = []
    end

    # Run `on_ready` hook.
    #
    # Should be called after plug-ins are registered, before handling queries.
    #
    # @hook on_ready
    #
    # @return [self]
    def ready
      run_hook :on_ready
      self
    end

    # Run `on_shutdown` hook.
    #
    # Should be called after all queries are handled, before program
    # termination.
    #
    # @hook on_shutdown
    #
    # @return [void]
    def shutdown
      run_hook :on_shutdown
    end

    # Adds a new capability, which documents functionality added by a plug-in.
    #
    # @example Add a capability to the robot instance
    #   robot.can 'repeat what you say'
    #
    # @param desc [String] capability description
    # @return [Array] all capabilities registered to the robot
    #
    # @see Capability
    def can(desc)
      @capabilities << Capability.new(desc)
    end

    # Register a new query handler.
    #
    # The robot will execute the given block (the "action") when the given
    # pattern (the "condition") matches. Conditions are assigned priorities,
    # which determined in what order conditions are checked against the query.
    #
    # @example Add a handler to the robot instance
    #   robot.on(/^pattern/) do
    #     # ...
    #   end
    #
    # @example Add a handler with priority to the robot instance
    #   robot.on(/^pattern/, 7) do
    #     # ...
    #   end
    #
    # @example Add multiple handlers for the same action
    #   robot.on(
    #     /pattern/ => 6,
    #     /other pattern/ => 7,
    #     /another/ => 3,
    #   ) do
    #     # ...
    #   end
    #
    # @example Passing a lambda as a condition
    #   robot.on(->(query) { query.length > 10 }) do
    #     # ...
    #   end
    #
    # @param condition [Proc, #match] the condition that triggers the supplied action
    # @param priority [Integer] the handler priority (higher number = higher priority)
    # @param action [Proc] the block to be executed when condition is met
    # @return [void]
    #
    # @see Handler#initialize
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

    # Run action with given parameters in the context of the robot instance.
    #
    # @hook before_action
    # @hook after_action
    #
    # @param action [#call] the action
    # @param params the action parameters
    # @return result of the action
    def run_action(action, params)
      run_hook :before_action, action, params
      result = instance_exec(params, &action)
      run_hook :after_action, action, params, result
      result
    end

    # Run the action for the highest-priority handler that can handle the given
    # query and return the result. Associated hooks are run before and after
    # running the action.
    #
    # @hook before_handle_query
    # @hook after_handle_query
    # @hook on_unhandled_query
    #
    # @param query [String] user query
    # @return [false] if query is not handled
    # @return result of the action
    #
    # @see Handler#handle
    def handle(query)
      run_hook :before_handle_query, query

      first_handler_for(query) do |handler, params|
        return run_action(handler.action, params).tap do |result|
          run_hook :after_handle_query, query, handler
        end
      end

      run_hook :on_unhandled_query, query
      false
    end

    # Find the highest-priority handler for a given query and return it. When a
    # block is passed, the block is called if and only if a handler is found,
    # passing the handler and parsed params as the block's arguments.
    #
    # @param query [String] user query
    # @return [nil] if no handler can handle query
    # @return [Handler] the first matching handler
    def first_handler_for(query)
      @handlers.sort.reverse_each do |handler|
        if params = handler.handle(query)
          yield(handler, params) if block_given?
          return handler
        end
      end

      nil
    end
  end
end
