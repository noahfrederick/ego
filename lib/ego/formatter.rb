require 'colorize'

module Ego
  class Formatter
    def initialize
      String.disable_colorization = !$stdout.isatty
    end

    def puts(message)
      $stdout.puts message
    end

    def robot_respond(message, *replacements)
      message = sprintf(message, *replacements)
      message = message[0].upcase + message[1..-1]

      $stdout.puts message.yellow
    end

    def robot_action(message)
      $stdout.puts "*#{message}*".magenta
    end

    def debug(message, *replacements)
      message = sprintf(message, *replacements)

      $stderr.puts message
    end

    def self.print_handlers(handlers)
      handlers.keys.sort.each do |key|
        $stdout.puts "- #{handlers[key]}"
      end
    end
  end
end
