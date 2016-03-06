require 'rubygems'

module Ego::Filesystem
  HANDLER_GLOB = 'handler/*.rb'

  BASENAME = Gem::Specification::load('ego.gemspec').name

  XDG_CACHE_HOME = ENV['XDG_CACHE_HOME'] || File.expand_path('~/.cache')
  XDG_CONFIG_HOME = ENV['XDG_CONFIG_HOME'] || File.expand_path('~/.config')
  XDG_DATA_HOME = ENV['XDG_DATA_HOME'] || File.expand_path('~/.local/share')

  module_function

  def cache path = ''
    File.join XDG_CACHE_HOME, BASENAME, path
  end

  def config path = ''
    File.join XDG_CONFIG_HOME, BASENAME, path
  end

  def data path = ''
    File.join XDG_DATA_HOME, BASENAME, path
  end

  def require_all_handlers
    require_builtin_handlers
  end

  def require_builtin_handlers
    builtin_handlers.each { |h| require h }
  end

  def builtin_handlers
    Dir[File.expand_path(HANDLER_GLOB, __dir__)]
  end
end
