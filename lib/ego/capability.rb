module Ego
  # A capability defines functionality added to a `Robot` instance by a
  # plug-in.
  #
  # @note New capabilities should be specified by plug-ins using the
  #   `robot#can` method.
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
    # @param plugin [Plugin] the plug-in that provides the capability
    def initialize(desc, plugin)
      @desc = desc
      @plugin = plugin
    end

    # @return [String] the capability description
    def to_s
      @desc
    end
  end
end
