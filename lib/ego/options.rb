require 'optparse'

module Ego
  class Options

    attr_reader :mode,
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
        opts.banner = "Usage: ego [ options ] query..."

        opts.on("-v", "--version", "Print version number") do
          @mode = :version
        end

        opts.on("-V", "--verbose", "Verbose output") do
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
