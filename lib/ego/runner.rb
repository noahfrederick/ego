require_relative '../ego'

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
      when :help
        if @options.usage_error
          STDERR.puts @options.usage_error, "\n"
        end

        @formatter.puts @options.usage

        exit(-1) if @options.usage_error
      when :version
        @formatter.puts "ego v#{Ego::VERSION}"
      else
        robot = Ego::Robot.new(@options, @formatter)
        Ego::Handler.load Ego::Filesystem.user_handlers
        Ego::Handler.load Ego::Filesystem.builtin_handlers
        Ego::Handler.dispatch robot, @options.query
      end
    end
  end
end
