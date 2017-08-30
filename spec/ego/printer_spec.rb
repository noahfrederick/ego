require 'ego/printer'

module Ego
  RSpec.describe Printer do
    let(:printer) do
      (Class.new do
        include Printer
        def verbose?; true; end
      end).new
    end

    describe '#puts' do
      it 'prints to STDOUT' do
        expect { Printer.puts 'bar' }.to output("bar\n").to_stdout
      end

      it 'concatenates multiple arguments' do
        expect { Printer.puts 'bar', 'baz' }.to output("bar\nbaz\n").to_stdout
      end
    end

    describe '#errs' do
      it 'prints to STDERR' do
        expect { Printer.errs 'bar' }.to output("bar\n").to_stderr
      end

      it 'concatenates multiple arguments' do
        expect { Printer.errs 'bar', 'baz' }.to output("bar\nbaz\n").to_stderr
      end
    end

    describe '#respond' do
      it 'prints the message to STDOUT with color and newline' do
        expect { printer.respond('X') }.to output("\e[0;33;49mX\e[0m\n").to_stdout
      end

      it 'accepts placeholders and replacement strings' do
        expect { printer.respond('Hello, %s.', 'world') }.to output("\e[0;33;49mHello, world.\e[0m\n").to_stdout
      end

      it 'capitalizes the first letter of the message' do
        expect { printer.respond('foo') }.to output("\e[0;33;49mFoo\e[0m\n").to_stdout
      end

      it 'capitalizes the first letter of the message when it is a replacement' do
        expect { printer.respond('%s', 'foo') }.to output("\e[0;33;49mFoo\e[0m\n").to_stdout
      end

      it 'does not lowercase subsequent letters' do
        expect { printer.respond('foO') }.to output("\e[0;33;49mFoO\e[0m\n").to_stdout
      end
    end

    describe '#it' do
      it 'prints the message to STDOUT with color and formatting' do
        expect { printer.it('FOO') }.to output("\e[0;35;49m*FOO*\e[0m\n").to_stdout
      end
    end

    describe '#debug' do
      it 'prints the message to STDERR with newline' do
        expect { printer.debug('FOO') }.to output("FOO\n").to_stderr
      end

      it 'accepts placeholders and replacement strings' do
        expect { printer.debug('Hello, %s.', 'world') }.to output("Hello, world.\n").to_stderr
      end
    end
  end
end
