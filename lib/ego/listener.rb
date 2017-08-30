module Ego
  # Listeners map user queries to handlers.
  class Listener
    include Comparable

    attr_accessor :pattern, :priority, :parser, :handler

    def initialize(pattern, priority, parser, handler)
      @pattern = pattern
      @priority = priority
      @parser = parser
      @handler = handler
    end

    def <=> other
      @priority <=> other.priority
    end

    def match(query)
      return false unless (matches = @pattern.match(query))

      @parser.call matches
    end
  end
end
