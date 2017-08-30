require 'ego/formatter'

module Ego
  RSpec.describe Formatter do
    before(:example) do
      @formatter = Formatter.new
    end

    describe '#puts' do
      it 'prints the message to STDOUT with newline' do
        expect { @formatter.puts('X') }.to output("X\n").to_stdout
      end
    end

    describe '#robot_respond' do
      it 'prints the message to STDOUT with color and newline' do
        expect { @formatter.robot_respond('X') }.to output("\e[0;33;49mX\e[0m\n").to_stdout
      end

      it 'accepts placeholders and replacement strings' do
        expect { @formatter.robot_respond('Hello, %s.', 'world') }.to output("\e[0;33;49mHello, world.\e[0m\n").to_stdout
      end

      it 'capitalizes the first letter of the message' do
        expect { @formatter.robot_respond('foo') }.to output("\e[0;33;49mFoo\e[0m\n").to_stdout
      end

      it 'capitalizes the first letter of the message when it is a replacement' do
        expect { @formatter.robot_respond('%s', 'foo') }.to output("\e[0;33;49mFoo\e[0m\n").to_stdout
      end

      it 'does not lowercase subsequent letters' do
        expect { @formatter.robot_respond('foO') }.to output("\e[0;33;49mFoO\e[0m\n").to_stdout
      end
    end

    describe '#robot_action' do
      it 'prints the message to STDOUT with color and formatting' do
        expect { @formatter.robot_action('FOO') }.to output("\e[0;35;49m*FOO*\e[0m\n").to_stdout
      end
    end

    describe '#debug' do
      it 'prints the message to STDERR with newline' do
        expect { @formatter.debug('FOO') }.to output("FOO\n").to_stderr
      end

      it 'accepts placeholders and replacement strings' do
        expect { @formatter.debug('Hello, %s.', 'world') }.to output("Hello, world.\n").to_stderr
      end
    end
  end
end
