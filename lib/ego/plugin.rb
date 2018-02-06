# frozen_string_literal: true

module Ego
  # A plug-in extends Ego with new handlers and other functionality, through a
  # domain-specific language (DSL).
  #
  # @see Robot
  class Plugin
    # Manifest of all registered plug-ins
    @@plugins = {}
    # Current plug-in context
    @@context = nil

    attr_reader :name, :body, :builtin

    # @param name [String] the plug-in name
    # @param body the plug-in body
    # @param builtin [Boolean] whether this is a built-in plug-in
    def initialize(name, body, builtin: false)
      @name = name
      @body = body
      @builtin = builtin
    end

    # Load all given plug-in paths
    #
    # @param paths [Array] absolute paths to plug-in files
    # @return [void]
    def self.load(paths)
      paths.each { |path| Kernel.load path }
    end

    # Register a new plug-in
    #
    # @note You should use `Ego.plugin` in plug-in scripts, which sets a
    #   plug-in name for you automatically.
    #
    # @param name [String] the plug-in name
    # @param body the plug-in body
    # @param builtin [Boolean] whether to register as a built-in plug-in
    # @return [Plugin] the instantiated plug-in
    def self.register(name, body, builtin: false)
      @@plugins[name] = Plugin.new(name, body, builtin: builtin)
    end

    # Yield each plug-in body passing `obj` as a parameter and calling
    # `obj#context=`.
    #
    # @param obj [Object] the object to decorate
    # @return [Object] the decorated object
    def self.decorate(obj)
      @@plugins.each_value do |plugin|
        @@context = plugin
        plugin.body.call(obj)
        @@context = nil
      end

      obj
    end

    # Get the currently executing plug-in.
    #
    # @return [Plugin] currently executing plugin
    def self.context
      @@context
    end
  end
end
