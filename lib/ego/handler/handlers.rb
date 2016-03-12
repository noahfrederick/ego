require_relative '../handler'

Ego::Handler.register do |handler|
  handler.description = 'tell you what I can do'

  handler.listen /^(show me|show|list)\s+(handlers|what you can do|what you are able to do|what you do)$/i
  handler.listen /^what (?:can you|are you able to|do you) (?:do|handle)\??$/i

  handler.run do |robot|
    robot.respond 'I know how to...'

    Ego::Formatter.print_handlers Ego::Handler.handlers
  end
end
