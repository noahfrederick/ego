require_relative 'runner'
require 'readline'

module Ego
  # The Ego::Shell class executes requests as a REPL.
  class Shell < Runner
    PROMPT = 'ego, '.green.freeze
    QUIT = /^q(uit)?|exit|(good)?bye$/.freeze

    protected

    def prompt
      Readline.readline(PROMPT, true)
    end

    def start_repl(robot)
      loop do
        query = prompt
        break if query.nil? || query.strip =~ QUIT
        Ego::Handler.dispatch robot, query.strip
      end
    end

    def handle_query
      robot = Ego::Robot.new(@options, @formatter)
      Ego::Handler.load Ego::Filesystem.user_handlers
      Ego::Handler.load Ego::Filesystem.builtin_handlers

      start_repl robot
    end
  end
end
