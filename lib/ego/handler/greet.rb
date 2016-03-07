handle /^(hello|salve|ave|hi|hey|ciao|hej)/i, priority: 3 do |robot|
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
