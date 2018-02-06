# frozen_string_literal: true

module Ego
  # Provides utility methods for getting configuration, data, and cache paths.
  module Filesystem
    # Glob pattern for matching plug-in files
    PLUGIN_GLOB = 'plugins/*.rb'

    # XDG subdirectoy name
    BASENAME = 'ego'

    # Value of `$XDG_CACHE_HOME` or fallback if not set
    XDG_CACHE_HOME = ENV['XDG_CACHE_HOME'] || File.expand_path('~/.cache')
    # Value of `$XDG_CONFIG_HOME` or fallback if not set
    XDG_CONFIG_HOME = ENV['XDG_CONFIG_HOME'] || File.expand_path('~/.config')
    # Value of `$XDG_DATA_HOME` or fallback if not set
    XDG_DATA_HOME = ENV['XDG_DATA_HOME'] || File.expand_path('~/.local/share')

    module_function

    # @param path [String] path to append
    # @return [String] the path to cache directory with `path` appended
    #
    # @see config
    # @see data
    def cache(path = '')
      File.join(XDG_CACHE_HOME, BASENAME, path)
    end

    # @param path [String] path to append
    # @return [String] the path to config directory with `path` appended
    #
    # @see cache
    # @see data
    def config(path = '')
      File.join(XDG_CONFIG_HOME, BASENAME, path)
    end

    # @param path [String] path to append
    # @return [String] the path to data directory with `path` appended
    #
    # @see cache
    # @see config
    def data(path = '')
      File.join(XDG_DATA_HOME, BASENAME, path)
    end

    # @return [Array] all built-in plug-in paths
    #
    # @see user_plugins
    def builtin_plugins
      Dir[File.expand_path(PLUGIN_GLOB, __dir__)]
    end

    # @return [Array] all user plug-in paths
    #
    # @see builtin_plugins
    def user_plugins
      Dir[File.expand_path(PLUGIN_GLOB, config)]
    end
  end
end
