module Ego
  class Robot
    attr_reader :name, :options

    def initialize options
      @name = options.robot_name
      @options = options
    end

    def respond response
      puts response
      true
    end

    def it does
      puts "*#{does}*"
      true
    end

    def debug message
      return unless @options.verbose
      puts "-> #{message}"
      true
    end

    def continue
      false
    end
  end
end
