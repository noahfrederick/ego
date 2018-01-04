require_relative 'ego/filesystem'
require_relative 'ego/robot'
require_relative 'ego/plugin'
require_relative 'ego/printer'
require_relative 'ego/version'

module Ego
  # Public interface for defining a plug-in.
  #
  # Ego looks for user-defined plug-ins in `$XDG_CONFIG_HOME/ego/plugins/`
  # (that's `~/.config/ego/plugins/` by default), and registers them
  # automatically at runtime. Each plug-in goes in it's own file with an `.rb`
  # extension (e.g., `~/.config/ego/plugins/my_plugin.rb`).
  #
  # Be careful—ego will execute any Ruby scripts in this directory
  # indiscriminately.
  #
  # @example Create and register a new plug-in
  #   # ~/.config/ego/plugins/echo.rb
  #   Ego.plugin do |robot|
  #     robot.can 'repeat what you say'
  #
  #     robot.on /^say (?<input>.+)/i do |params|
  #       say params[:input]
  #     end
  #   end
  #
  # @param name [String, nil] the plug-in name (uses plug-in file's basename if given `nil`)
  # @param body the plug-in body
  # @return [Plugin] the instantiated plug-in
  #
  # @see Robot
  def self.plugin(name = nil, &body)
    path = caller_locations(1, 1)[0].absolute_path
    name ||= File.basename(path, '.*')
    builtin = path.start_with?(__dir__)

    Plugin.register(name, body, builtin: builtin)
  end
end
