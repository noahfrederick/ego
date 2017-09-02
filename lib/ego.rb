require_relative 'ego/filesystem'
require_relative 'ego/robot'
require_relative 'ego/plugin'
require_relative 'ego/printer'
require_relative 'ego/version'

module Ego
  def self.plugin(name = nil, builtin: false, &body)
    if name.nil?
      path = caller_locations(1, 1)[0].absolute_path
      name = File.basename(path, '.*')
    end

    Plugin.register(name, body, builtin: builtin)
  end
end
