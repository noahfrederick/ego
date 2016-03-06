require_relative '../handler'

handle /.*/, priority: 0 do |robot|
  robot.respond 'I don\'t understand.'
end
