require_relative '../ego'

module Ego
  # The Ego::Runner class, given an array of arguments, initializes the
  # required objects and executes the request.
  class Runner
    PROMPT = 'ego, '.green.freeze
    QUIT = /^q(uit)?|exit|(good)?bye$/.freeze

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
      when :shell
        init_robot
        start_repl
      else
        init_robot
        handle_query @options.query
      end
    end

    protected

    def init_robot
      @robot = Ego::Robot.new(@options, @formatter)
      Ego::Handler.load Ego::Filesystem.user_handlers
      Ego::Handler.load Ego::Filesystem.builtin_handlers
    end

    def handle_query(query)
      Ego::Handler.dispatch @robot, query
    end

    def prompt
      Readline.readline(PROMPT, true)
    end

    def start_repl
      require 'readline'

      # Store the state of the terminal
      stty_save = `stty -g`.chomp

      loop do
        query = prompt
        break if query.nil? || query.strip =~ QUIT
        handle_query query.strip
      end
    rescue Interrupt => e
      system('stty', stty_save) # Restore state
    end
  end
end
