Ego.plugin do |robot|
  robot.can 'help you write plug-ins'

  robot.on_unhandled_query do |query|
    require 'ego/plugin_helper'

    helper = Ego::PluginHelper.new(
      query: query,
      program_name: options.usage.program_name
    )

    if $stdout.isatty
      alert helper.hint
    end

    if verbose? || !$stdout.isatty
      puts helper.template
    end
  end
end
