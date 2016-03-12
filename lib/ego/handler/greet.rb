Ego::Handler.register do |handler|
  handler.description = 'greet you'

  handler.listen /^(hello|salve|ave|hi|hey|ciao|hej)/i, priority: 3

  handler.run do |robot|
    robot.respond [
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
