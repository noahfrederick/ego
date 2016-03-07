handle /(.*)/, priority: 0 do |robot, matches|
  robot.respond %Q{I don't understand "#{matches[0]}".}

  STDERR.puts <<-EOF
Perhaps add a handler to #{Ego::Filesystem.config 'handler/{}.rb'}:

handle /^#{matches[0]}$/i do |robot|
  # Do it
end
EOF
end
