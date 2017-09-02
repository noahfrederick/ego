Ego.plugin builtin: true do |robot|
  robot.can 'output text to the terminal'

  # Provide #say, #emote, #alert, and #debug
  robot.extend(Ego::Printer)

  # A verbose robot doesn't suppress #debug output
  robot.provide :verbose? do
    @options.verbose
  end

  robot.can 'repeat what you say'
  robot.on(/^(?:say|echo)\s+(?<input>.+)/i) do |match|
    say match[:input]
  end
end
