module Ego::Filesystem
  HANDLER_GLOB = 'handler/*.rb'

  module_function

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
