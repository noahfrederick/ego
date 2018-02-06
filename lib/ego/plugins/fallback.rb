# frozen_string_literal: true

Ego.plugin do |robot|
  robot.can 'help you write plug-ins'

  robot.on_unhandled_query do |query|
    require_relative '../plugin_helper'

    helper = Ego::PluginHelper.new(
      query: query,
      program_name: options.usage.program_name
    )

    alert helper.hint if $stdout.isatty

    puts helper.template if verbose? || !$stdout.isatty
  end
end
