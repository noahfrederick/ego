module Ego
  class Robot
    attr_reader :name, :options

    def initialize options, formatter
      @name = options.robot_name
      @options = options
      @formatter = formatter
    end

    def respond message
      @formatter.robot_respond message
      true
    end

    def it message
      @formatter.robot_action message
      true
    end

    def debug message
      return unless @options.verbose
      @formatter.debug message
      true
    end

    def stop
      true
    end

    def continue
      false
    end
  end
end
