Ego::Handler.register do |handler|
  handler.description = 'let you know when I don\'t understand something'

  handler.listen /(.*)/, priority: 0

  handler.run do |robot, params|
    robot.respond %Q{I don't understand "#{params[0]}".}

    STDERR.puts <<-EOF
Perhaps add a handler to #{Ego::Filesystem.config 'handler/{}.rb'}:

...
    EOF
  end
end
