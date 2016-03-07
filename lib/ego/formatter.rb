require 'colorize'

module Ego
  class Formatter
    def initialize
      String.disable_colorization = !STDOUT.isatty
    end

    def puts message
      STDOUT.puts message
    end

    def robot_respond message
      STDOUT.puts message.yellow
    end

    def robot_action message
      STDOUT.puts "*#{message}*".magenta
    end

    def debug message
      STDERR.puts message
    end

    def self.print_handlers handlers
      handlers.keys.sort.each do |key|
        STDOUT.puts handlers[key]
      end
    end
  end
end
