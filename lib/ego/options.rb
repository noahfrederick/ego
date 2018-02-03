require 'optparse'

module Ego
  # Parse command-line options and set defaults.
  class Options

    attr_reader :mode,
                :plugins,
                :robot_name,
                :verbose,
                :query,
                :usage,
                :usage_error

    # @param argv [Array] command-line arguments
    def initialize(argv)
      @mode = :interpret
      @plugins = true
      @verbose = false
      parse(argv)
      @query = argv.join(" ")
    end

    private

    # Parse the arguments supplied at the command line and set options
    # accordingly.
    #
    # @param argv [Array] command-line arguments
    # @return [void]
    def parse(argv)
      OptionParser.new do |opts|
        @robot_name = opts.program_name.capitalize
        opts.banner = "Usage: #{opts.program_name} [ options ] query..."

        opts.on("-n", "--no-plugins", "Skip loading user plug-ins") do
          @plugins = false
        end

        opts.on("-s", "--shell", "Start in REPL-mode") do
          @mode = :shell
        end

        opts.on("-t", "--template", "Create a new plug-in") do
          @mode = :template
        end

        opts.on("-v", "--version", "Print version number") do
          @mode = :version
        end

        opts.on("-V", "--verbose", "Include debugging info in output") do
          @verbose = true
        end

        opts.on("-h", "--help", "Show this message") do
          @mode = :help
        end

        begin
          argv = ["-h"] if argv.empty?
          opts.parse!(argv)
        rescue OptionParser::ParseError => e
          @usage_error = e.message
          @mode = :help
        ensure
          @usage = opts
        end
      end
    end
  end
end
