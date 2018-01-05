require 'ego/printer'

module Ego
  RSpec.describe Printer do
    let(:verbose_printer) { (Class.new { include Printer; def verbose?; true; end }).new }
    let(:printer) { (Class.new { include Printer }).new }

    before :all { String.disable_colorization = false }
    after :all { String.disable_colorization = true }

    describe '#puts' do
      it 'is callable on the module' do
        expect(described_class.respond_to?(:puts)).to be true
      end

      it 'is private on the instance' do
        expect(printer.respond_to?(:puts)).to be false
      end

      it 'prints to STDOUT' do
        expect { described_class.puts 'bar' }.to output("bar\n").to_stdout
      end

      it 'concatenates multiple arguments' do
        expect { described_class.puts 'bar', 'baz' }.to output("bar\nbaz\n").to_stdout
      end
    end

    describe '#errs' do
      it 'is callable on the module' do
        expect(described_class.respond_to?(:errs)).to be true
      end

      it 'is private on the instance' do
        expect(printer.respond_to?(:errs)).to be false
      end

      it 'prints to STDERR' do
        expect { described_class.errs 'bar' }.to output("bar\n").to_stderr
      end

      it 'concatenates multiple arguments' do
        expect { described_class.errs 'bar', 'baz' }.to output("bar\nbaz\n").to_stderr
      end
    end

    describe '#say' do
      it 'is not callable on the module' do
        expect(described_class.respond_to?(:say)).to be false
      end

      it 'is callable on the instance' do
        expect(printer.respond_to?(:say)).to be true
      end

      it 'prints the message to STDOUT bolded with newline' do
        expect { printer.say('X') }.to output("\e[1;39;49mX\e[0m\n").to_stdout
      end

      it 'accepts placeholders and replacement strings' do
        expect { printer.say('Hello, %s.', 'world') }.to output("\e[1;39;49mHello, world.\e[0m\n").to_stdout
      end
    end

    describe '#emote' do
      it 'is not callable on the module' do
        expect(described_class.respond_to?(:emote)).to be false
      end

      it 'is callable on the instance' do
        expect(printer.respond_to?(:emote)).to be true
      end

      it 'prints the message to STDOUT with color and asterisks' do
        expect { printer.emote('FOO') }.to output("\e[0;35;49m*FOO*\e[0m\n").to_stdout
      end
    end

    describe '#alert' do
      it 'is not callable on the module' do
        expect(described_class.respond_to?(:alert)).to be false
      end

      it 'is callable on the instance' do
        expect(printer.respond_to?(:alert)).to be true
      end

      it 'prints the message to STDERR with color and newline' do
        expect { printer.alert('FOO') }.to output("\e[0;91;49mFOO\e[0m\n").to_stderr
      end

      it 'accepts placeholders and replacement strings' do
        expect { printer.alert('Error: %s.', 'foo') }.to output("\e[0;91;49mError: foo.\e[0m\n").to_stderr
      end
    end

    describe '#debug' do
      it 'is not callable on the module' do
        expect(described_class.respond_to?(:debug)).to be false
      end

      it 'is callable on the instance' do
        expect(printer.respond_to?(:debug)).to be true
      end

      context 'in verbose instance' do
        it 'prints the message to STDERR with newline' do
          expect { verbose_printer.debug('FOO') }.to output("FOO\n").to_stderr
        end

        it 'accepts placeholders and replacement strings' do
          expect { verbose_printer.debug('Hello, %s.', 'world') }.to output("Hello, world.\n").to_stderr
        end
      end

      context 'in default instance' do
        it 'does not print anything' do
          expect { printer.debug('FOO') }.not_to output.to_stderr
        end
      end
    end
  end
end
