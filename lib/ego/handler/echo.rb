require_relative '../handler'

handle /^(say|echo)\s+(.*)$/i do |robot, matches|
  robot.respond matches[2]
end
