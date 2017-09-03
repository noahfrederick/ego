require_relative '../ego'
require_relative 'options'

module Ego
  # The Runner class, given an array of arguments, initializes the required
  # objects and executes the request.
  class Runner
    # Prompt to display in shell-mode
    PROMPT = 'ego, '.green.freeze
    # Pattern that triggers shell-mode to exit
    QUIT = /^q(uit)?|exit|(good)?bye$/.freeze

    # Takes an array of arguments and parses them into options:
    #
    # @example
    #   runner = Ego::Runner.new(ARGV)
    #
    # @param argv [Array] command-line arguments
    def initialize(argv)
      @options = Options.new(argv)
    end

    # Run the appropriate action based on the arguments provided to
    # `#initialize`.
    #
    # @return [void]
    def run
      case @options.mode
      when :help
        if @options.usage_error
          Printer.errs @options.usage_error, "\n"
        end

        Printer.puts @options.usage

        exit(-1) if @options.usage_error
      when :version
        Printer.puts "ego v#{Ego::VERSION}"
      when :shell
        start_shell(robot_factory)
      else
        handle_query(robot_factory, @options.query)
      end
    rescue RobotError => e
      Printer.errs e.message
      exit(-2)
    end

    protected

    # Get a robot and enhance it with plug-ins.
    #
    # @return [Robot] a decorated robot instance
    def robot_factory
      Plugin.load Filesystem.builtin_plugins

      if @options.plugins
        Plugin.load Filesystem.user_plugins
      end

      Plugin.decorate(Robot.new(@options)).ready
    end

    # Handle and single query and shut down.
    #
    # @param robot [Robot] the robot to handle the query
    # @param query [String] the query to handle
    # @return [void]
    def handle_query(robot, query)
      robot.handle(query)
    ensure
      robot.shutdown
    end

    # Show a prompt and read input from the user.
    #
    # @return [String, nil] the user query
    def prompt
      Readline.readline(PROMPT, true)
    end

    # Start a REPL for handling multiple queries in one session.
    #
    # @param robot [Robot] the robot to handle the query
    # @return [void]
    def start_shell(robot)
      require 'readline'

      # Save the state of the terminal
      stty_save = `stty -g`.chomp

      loop do
        query = prompt
        break if query.nil? || query.strip =~ QUIT
        robot.handle(query.strip)
      end
    rescue Interrupt => e
      system('stty', stty_save) # Restore state
      robot.say e.message
    ensure
      robot.shutdown
    end
  end
end
