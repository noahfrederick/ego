require 'colorize'

module Ego
  module Printer
    String.disable_colorization = !$stdout.isatty

    def respond(message, *replacements)
      message = sprintf(message, *replacements)
      message = message[0].upcase + message[1..-1]

      puts message.yellow
    end

    def it(message)
      puts "*#{message}*".magenta
    end

    def debug(message, *replacements)
      return unless verbose?
      message = sprintf(message, *replacements)

      errs message
    end

    module_function

    def print_handlers(handlers)
      handlers.keys.sort.each do |key|
        puts "- #{handlers[key]}"
      end
    end

    def puts(*message)
      $stdout.puts(*message)
    end

    def errs(*message)
      $stderr.puts(*message)
    end

    def verbose?
      false
    end
  end
end
