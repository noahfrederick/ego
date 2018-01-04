Ego.plugin do |robot|
  robot.can 'execute system commands'

  robot.provide :system do |*args|
    debug 'Running system with arguments %s.', args

    unless Kernel.system(*args)
      alert 'Sorry, there was a problem running %s.', args.first
    end
  end

  robot.can 'tell you your login name'

  robot.on(
    /^what(?:'?s| is) my (?:user|login)? ?name/i => 5,
    /^who am I(?: logged in as)?/i => 5,
  ) do
    say 'You are currently logged in as:'
    system 'who'
  end
end
