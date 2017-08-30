require_relative 'printer'
require_relative 'plugin'
require 'hooks'

module Ego
  class Robot
    include Printer
    include Hooks
    include Hooks::InstanceHooks
    include Plugin

    attr_reader :name, :options

    define_hooks :after_init,
                 :before_run,
                 :after_run,
                 :before_shutdown

    def initialize(options)
      @name = options.robot_name
      @options = options

      init_plugins
      run_hook :after_init
    end

    def shutdown
      run_hook :before_shutdown
    end

    def verbose?
      @options.verbose
    end
  end
end
