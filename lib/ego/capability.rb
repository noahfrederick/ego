module Ego
  class Capability
    attr_reader :desc, :plugin

    def initialize(desc, plugin)
      @desc = desc
      @plugin = plugin
    end

    def to_s
      @desc
    end
  end
end
