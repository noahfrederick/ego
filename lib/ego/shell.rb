require_relative '../ego'
require 'readline'

module Ego
  # The Ego::Shell class executes requests as a REPL.
  class Shell
    PROMPT = 'ego, '.green.freeze

    def initialize
      @formatter = Ego::Formatter.new

      Ego::Handler.load Ego::Filesystem.user_handlers
      Ego::Handler.load Ego::Filesystem.builtin_handlers
    end

    def prompt
      Readline.readline(PROMPT, true).strip
    end

    def run
      loop do
        line = prompt
        break if line =~ /^q(uit)?|exit|(good)?bye$/
        run_line line.split
      end
    end

    def run_line(args)
      @options = Options.new(args)

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
        Ego::Handler.dispatch robot, @options.query
      end
    end
  end
end
