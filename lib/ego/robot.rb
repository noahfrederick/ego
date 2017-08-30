module Ego
  class Robot
    attr_reader :name, :options

    def initialize(options, formatter)
      @name = options.robot_name
      @options = options
      @formatter = formatter
    end

    def respond(message, *replacements)
      @formatter.robot_respond message, *replacements
    end

    def it(message)
      @formatter.robot_action message
    end

    def debug(message, *replacements)
      return unless @options.verbose
      @formatter.debug message, *replacements
    end
  end
end
