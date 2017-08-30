module Ego::Filesystem
  HANDLER_GLOB = 'handler/*.rb'

  BASENAME = 'ego'

  XDG_CACHE_HOME = ENV['XDG_CACHE_HOME'] || File.expand_path('~/.cache')
  XDG_CONFIG_HOME = ENV['XDG_CONFIG_HOME'] || File.expand_path('~/.config')
  XDG_DATA_HOME = ENV['XDG_DATA_HOME'] || File.expand_path('~/.local/share')

  module_function

  def cache(path = '')
    File.join(XDG_CACHE_HOME, BASENAME, path)
  end

  def config(path = '')
    File.join(XDG_CONFIG_HOME, BASENAME, path)
  end

  def data(path = '')
    File.join(XDG_DATA_HOME, BASENAME, path)
  end

  def builtin_handlers
    Dir[File.expand_path(HANDLER_GLOB, __dir__)]
  end

  def user_handlers
    Dir[File.expand_path(HANDLER_GLOB, config)]
  end
end
