Ego::Handler.register do |handler|
  handler.description = 'tell you who I am'

  handler.listen /^(who are you|what('?s| is) your name)/i

  handler.run do |robot|
    robot.respond ["#{robot.name} sum.", "This is #{robot.name}, a robot."].sample
  end
end
