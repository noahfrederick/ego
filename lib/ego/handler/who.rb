require_relative '../handler'

handle /^(who are you|what'?s your name)/i do |robot|
  robot.respond ['Ego sum.', 'This is ego, a robot.'].sample
end
