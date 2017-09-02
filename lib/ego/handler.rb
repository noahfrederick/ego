require_relative 'robot_error'

module Ego
  # Listeners map user queries to handlers.
  class Handler
    include Comparable

    attr_reader :condition, :action, :priority

    def initialize(condition, action, priority = 5)
      @condition = normalize(condition)
      @action = action
      @priority = priority
    end

    def <=> other
      @priority <=> other.priority
    end

    def handle(query)
      @condition.call(query) || false
    end

    protected

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
