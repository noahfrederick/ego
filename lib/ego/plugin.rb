module Ego
  module Plugin
    @@plugins = {}

    module_function

    def self.load(plugins)
      plugins.each { |plugin| require plugin }
    end

    def self.register(name = nil, &body)
      if name.nil?
        path = caller_locations(1, 1)[0].absolute_path
        name = File.basename(path, '.*')
      end

      @@plugins[name] = body
    end

    def init_plugins
      @@plugins.each { |name, body| body.call(self) }
    end
  end
end
