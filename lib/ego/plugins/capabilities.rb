Ego.plugin do |robot|
  robot.can 'list capabilities'

  robot.on(
    /^(show me|show|tell me|list)\s+(handlers|what you can do|what (?:you are|you're) able to do|what you do|what (?:queries )?you (?:can )?understand)$/i => 5,
    /^what (?:can you|are you able to|do you) (?:do|handle|understand)\??$/i => 5,
    /^help/i => 2,
  ) do
    say 'I can...'

    @capabilities.each do |cap|
      builtin = cap.plugin.builtin ? '*' : ''
      plugin = sprintf('(%s%s)', cap.plugin.name, builtin).magenta
      printf("- %s %s\n", cap.to_s, plugin)
    end
  end

  # Returns `true` if any registered handler can handle the given query.
  #
  # @param query [String] user query
  # @return [Boolean] whether any handler matches the query
  robot.provide :understand? do |query|
    !first_handler_for(query).nil?
  end

  robot.on(/^(can|do|would) you understand\s+(?<query>.+)/i => 6) do |match|
    if understand?(match[:query])
      say 'Yes, I understand that.'
    else
      say 'No, I do not understand that.'
    end
  end
end
