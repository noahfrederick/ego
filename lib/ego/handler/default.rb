Ego::Handler.register do |handler|
  handler.description = 'let you know when I don\'t understand something'

  handler.listen /(.*)/, priority: 0

  handler.run do |robot, params|
    robot.respond %Q{I don't understand "#{params[0]}".}

    handler_slug = params[0]
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .tr('\'', '')
      .gsub(/\W+/, '_')
      .gsub(/__+/, '_')
      .downcase

    STDERR.puts <<-EOF
Perhaps add a handler to #{Ego::Filesystem.config "handler/#{handler_slug}.rb"}:

Ego::Handler.register do |handler|
  handler.description = 'do something'

  handler.listen /^#{params[0]}$/

  handler.run do |robot, params|
    # ...
  end
end
    EOF
  end
end
