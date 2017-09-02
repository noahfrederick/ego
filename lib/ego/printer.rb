require 'colorize'

module Ego
  module Printer
    String.disable_colorization = !$stdout.isatty

    def say(message, *replacements)
      puts sprintf(message, *replacements).bold
    end

    def emote(message)
      puts "*#{message}*".magenta
    end

    def alert(message, *replacements)
      errs sprintf(message, *replacements).light_red
    end

    def debug(message, *replacements)
      errs sprintf(message, *replacements) if verbose?
    end

    def verbose?; false; end

    module_function

    def puts(*message)
      $stdout.puts(*message)
    end

    def errs(*message)
      $stderr.puts(*message)
    end
  end
end
