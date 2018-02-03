require 'ego/filesystem'

module Ego
  # The PluginHelper assists the user in writing extensions by generating
  # boilerplate code.
  #
  # @see Plugin
  class PluginHelper
    # @param query [String] example user query
    # @param program_name [String] the executable name
    def initialize(query:, program_name:)
      @query = query
      @program_name = program_name
    end

    # Derive a slug from the user query.
    #
    # @return [String] slug
    def slug
      @slug ||= @query
        .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .tr('\'', '')
        .gsub(/\W+/, '_')
        .gsub(/__+/, '_')
        .sub(/_$/, '')
        .downcase
    end

    # Derive a plug-in path from the user query.
    #
    # @return [String] plug-in path
    def path
      @path ||= Filesystem.config("plugins/#{slug}.rb")
        .sub(/^#{ENV['HOME']}/, '~')
    end

    # Provide a hint for initializing a new plug-in.
    #
    # @return [String] hint text
    def hint
      require 'shellwords'
      @hint ||= <<~EOF
        I don't understand "#{@query}".

        If you would like to add this capability, start by running:
          #{@program_name} #{@query.shellescape} > #{path}
      EOF
    end

    # Provide a template for initializing a new plug-in.
    #
    # @return [String] template contents
    def template
      @template ||= <<~EOF
        Ego.plugin do |robot|
          robot.can 'do something new'

          robot.on(/^#{@query}$/i) do |params|
            alert 'Not implemented yet. Go ahead and edit #{path}.'
          end
        end
      EOF
    end
  end
end
