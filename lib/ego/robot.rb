require_relative 'printer'

module Ego
  class Robot
    include Printer

    attr_reader :name, :options

    def initialize(options)
      @name = options.robot_name
      @options = options
    end

    def verbose?
      @options.verbose
    end
  end
end
