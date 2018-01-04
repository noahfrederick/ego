require 'colorize'

module Ego
  # Utility methods for writing output with formatting.
  module Printer
    String.disable_colorization = !$stdout.isatty

    # Write stylized message to `$stdout` indicating speech.
    #
    # @example
    #   name = 'world'
    #   robot.say 'Hello, %s.', name
    #   # => "Hello, world."
    #
    # @param message [Object] message to write
    # @param *replacements [Object, ...] `printf`-style replacements
    # @return [nil]
    def say(message, *replacements)
      puts sprintf(message, *replacements).bold
    end

    # Write stylized message to `$stdout` indicating an emote.
    #
    # Plug-ins may use this method to indicate what the robot is doing.
    #
    # @example
    #   robot.emote 'runs away'
    #   # => "*runs away*"
    #
    # @param message [Object] message to write
    # @return [nil]
    def emote(message)
      puts "*#{message}*".magenta
    end

    # Write stylized message to `$stderr` indicating an error or warning
    # message.
    #
    # @example
    #   name = 'world'
    #   robot.alert 'Hello, %s.', name
    #   # => "Hello, world."
    #
    # @param message [Object] message to write
    # @param *replacements [Object, ...] `printf`-style replacements
    # @return [nil]
    def alert(message, *replacements)
      errs sprintf(message, *replacements).light_red
    end

    # Write stylized message to `$stderr` indicating a debugging message.
    #
    # Plug-ins may use this method to provide extra information when the
    # `--verbose` flag is supplied at the command-line.
    #
    # @example
    #   result = 'output'
    #   robot.debug 'Result: %s.', result
    #   # => "Result: output"
    #
    # @param message [Object] message to write
    # @param *replacements [Object, ...] `printf`-style replacements
    # @return [nil]
    def debug(message, *replacements)
      errs sprintf(message, *replacements) if verbose?
    end

    # Whether to print debugging messages. Can be overridden by classes that
    # include `Printer`.
    #
    # @return [false] should print debugging messages?
    def verbose?; false; end

    module_function

    # Writes the given message(s) to `$stdout`, appending a newline if not
    # already included.
    #
    # @param *message [Object, ...] message(s) to write
    # @return [nil]
    def puts(*message)
      $stdout.puts(*message)
    end

    # Writes the given message(s) to `$stderr`, appending a newline if not
    # already included.
    #
    # @param *message [Object, ...] message(s) to write
    # @return [nil]
    def errs(*message)
      $stderr.puts(*message)
    end
  end
end
