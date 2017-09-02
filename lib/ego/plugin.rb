module Ego
  class Plugin
    @@plugins = {}

    attr_reader :name, :body, :builtin

    def initialize(name, body, builtin: false)
      @name = name
      @body = body
      @builtin = builtin
    end

    def self.load(paths)
      paths.each { |path| require path }
    end

    def self.register(name, body, builtin: false)
      @@plugins[name] = Plugin.new(name, body, builtin: builtin)
    end

    def self.decorate(obj)
      @@plugins.each do |name, plugin|
        if obj.respond_to?(:context)
          obj.context = plugin
        end
        plugin.body.call(obj)
      end

      obj
    end
  end
end
