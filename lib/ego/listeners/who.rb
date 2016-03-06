require_relative '../robot'

Ego::Robot.listen /^(who are you|what'?s your name)/i do |robot|
  robot.respond ['Ego sum.', 'This is ego, a robot.'].sample
end
