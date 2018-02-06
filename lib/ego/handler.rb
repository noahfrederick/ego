# frozen_string_literal: true

require_relative 'robot_error'

module Ego
  # Handlers map user queries to actions.
  #
  # @note Handlers should be registered by plug-ins using the `Robot#on`
  #   method.
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
  # @see Robot#on
  class Handler
    include Comparable

    attr_reader :condition, :action, :priority

    # @param condition [Proc, #match] the condition that triggers the supplied action
    # @param action [Proc] the block to be executed when condition is met
    # @param priority [Integer] the handler priority (higher number = higher priority)
    def initialize(condition, action, priority = 5)
      @condition = normalize(condition)
      @action = action
      @priority = priority
    end

    # Compare `priority` with `other.priority`.
    #
    # @param other [Handler] the handler to compare with
    def <=>(other)
      @priority <=> other.priority
    end

    # Match the given query against the condition.
    #
    # @param query [String] the query to match the condition against
    # @return [false] if condition doesn't match
    # @return [Array] parameters to pass to the action
    def handle(query)
      return false unless (result = @condition.call(query))

      @action.parameters.each_with_object([]) do |param, arr|
        arr << result[param.pop]
      end
    end

    protected

    # Normalize the condition to a callable object.
    #
    # @param condition [Proc, #match] the condition that triggers the supplied action
    def normalize(condition)
      if condition.respond_to?(:match)
        # Must assign regexp to avoid recursion in lambda
        regexp = condition
        condition = ->(query) { regexp.match(query) }
      end

      condition
    end
  end
end
