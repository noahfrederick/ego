require 'optparse'

module Ego
  class Options

    attr_reader :mode,
                :robot_name,
                :verbose,
                :query,
                :usage,
                :usage_error

    def initialize(argv)
      @mode = :interpret
      @verbose = false
      parse(argv)
      @query = argv.join(" ")
    end

  private

    def parse(argv)
      OptionParser.new do |opts|
        @robot_name = opts.program_name.capitalize
        opts.banner = "Usage: #{opts.program_name} [ options ] query..."

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
