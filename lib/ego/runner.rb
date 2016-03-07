require_relative 'version'
require_relative 'options'
require_relative 'filesystem'
require_relative 'robot'
require_relative 'handler'

module Ego
  # The Ego::Runner class, given an array of arguments, initializes the
  # required objects and executes the request.
  class Runner
    # Takes an array of arguments and parses them into options:
    #
    #   runner = Ego::Runner.new(ARGV)
    #
    def initialize(argv)
      @options = Options.new(argv)
      @formatter = Ego::Formatter.new
    end

    # Run the appropriate action based on the arguments provided to
    # #initialize.
    def run
      case @options.mode
      when :version
        @formatter.puts "ego v#{Ego::VERSION}"
      else
        Ego::Handler.load Ego::Filesystem.user_handlers
        Ego::Handler.load Ego::Filesystem.builtin_handlers
        Ego::Handler.dispatch Ego::Robot.new(@options, @formatter), @options.query
      end
    end
  end
end
