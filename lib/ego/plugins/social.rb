Ego.plugin builtin: true do |robot|
  robot.can 'socialize'

  robot.on(/^((who|what) are you|what('?s| is) your name)/i) do
    say ["I'm #{name}.", "This is #{robot.name}, a robot."].sample
  end

  robot.on(/^(hello|salve|ave|hi|hey|ciao|hej)/i => 3) do
    say [
      'Hello.',
      'Salve tu.',
      'Ave.',
      'Hi.',
      'Hey.',
      'Ciao.',
      'Hej.',
    ].sample
  end
end
