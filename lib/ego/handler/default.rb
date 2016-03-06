require_relative '../handler'

handle /(.*)/, priority: 0 do |robot, matches|
  robot.respond %Q{I don't understand "#{matches[0]}".}
end
