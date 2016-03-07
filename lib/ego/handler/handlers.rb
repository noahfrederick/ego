require_relative '../handler'

handle /^(show me|show|list)\s+(handlers|what you can do)$/i do |robot|
  robot.respond 'Here are all the things I know how to do:'

  Ego::Formatter.print_handlers Ego::Handler.handlers

  robot.stop
end
