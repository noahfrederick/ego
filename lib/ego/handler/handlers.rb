require_relative '../handler'

Ego::Handler.register do |handler|
  handler.description = 'tell you what I can do'

  handler.listen /^(show me|show|tell me|list)\s+(handlers|what you can do|what (?:you are|you're) able to do|what you do|what (?:queries )?you (?:can )?understand)$/i
  handler.listen /^what (?:can you|are you able to|do you) (?:do|handle|understand)\??$/i
  handler.listen /^help/i, priority: 2

  handler.run do |robot|
    robot.respond 'I know how to...'

    Ego::Printer.print_handlers Ego::Handler.handlers
  end
end
