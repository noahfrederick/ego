handle /^(who are you|what('?s| is) your name)/i do |robot|
  robot.respond ["#{robot.name} sum.", "This is #{robot.name}, a robot."].sample
end
