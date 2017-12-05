Ego.plugin builtin: true do |robot|
  robot.can 'help you write extensions'

  robot.on_unhandled_query do |query|
    plugin_slug = query
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .tr('\'', '')
      .gsub(/\W+/, '_')
      .gsub(/__+/, '_')
      .downcase

    plugin_path = Ego::Filesystem.config("plugins/#{plugin_slug}.rb")
    plugin_path.sub!(/^#{ENV['HOME']}/, '~')

    if $stdout.isatty
      require 'shellwords'
      alert %q(I don't understand "%s".), query
      alert ''
      alert 'If you would like to add this capability, start by running:'
      alert '  %s %s > %s', $PROGRAM_NAME, query.shellescape, plugin_path
    end

    if verbose? || !$stdout.isatty
      puts <<~EOF
        Ego.plugin do |robot|
          robot.can 'do something new'

          robot.on(/^#{query}$/i) do |params|
            alert 'Not implemented yet. Go ahead and edit #{plugin_path}.'
          end
        end
      EOF
    end
  end
end
