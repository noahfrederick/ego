require_relative 'plugin'

module Ego
  # A capability defines functionality added to a `Robot` instance by a
  # plug-in.
  #
  # @note New capabilities should be specified by plug-ins using the
  #   `Robot#can` method.
  #
  # @example Add a capability to the robot instance
  #   Ego.plugin do |robot|
  #     robot.can 'repeat what you say'
  #     # ...
  #   end
  #
  # @see Robot#can
  class Capability
    attr_reader :desc, :plugin

    # @param desc [String] the capability description answering "What can the robot do?"
    def initialize(desc)
      @desc = desc
      @plugin = Plugin.context
    end

    # @return [String] the capability description
    def to_s
      @desc
    end
  end
end
