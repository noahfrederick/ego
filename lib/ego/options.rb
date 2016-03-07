require 'optparse'

module Ego
  class Options

    attr_reader :mode,
                :robot_name,
                :verbose,
                :query

    def initialize(argv)
      @mode = :interpret
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
          puts opts
          exit
        end

        begin
          argv = ["-h"] if argv.empty?
          opts.parse!(argv)
        rescue OptionParser::ParseError => e
          STDERR.puts e.message, "\n", opts
          exit(-1)
        end
      end
    end

  end
end
