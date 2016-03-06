require_relative '../handler'

handle /^(who are you|what'?s your name)/i do |robot|
  robot.respond ["#{robot.name} sum.", "This is #{robot.name}, a robot."].sample
end
