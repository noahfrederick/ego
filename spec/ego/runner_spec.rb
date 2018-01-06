require 'ego/runner'

RSpec.describe Ego::Runner do
  context 'with empty arguments' do
    subject { described_class.new([]) }

    it 'prints usage help' do
      expect { subject.run }.to output(
        /^Usage:/
      ).to_stdout
    end
  end

  context 'with --help' do
    subject { described_class.new(['--help']) }

    it 'prints usage help' do
      expect { subject.run }.to output(
        /^Usage:/
      ).to_stdout
    end
  end

  context 'with --version' do
    subject { described_class.new(['--version']) }

    it 'prints gem version' do
      expect { subject.run }.to output(
        "ego v#{Ego::VERSION}\n"
      ).to_stdout
    end
  end

  context 'with invalid arguments' do
    subject { described_class.new(['--invalid-flag']) }

    it 'prints usage error and help' do
      expect { subject.run }.to raise_exception(SystemExit).and output(
        /^invalid option:/
      ).to_stderr.and output(
        /^Usage:/
      ).to_stdout
    end
  end

  context 'with simple query' do
    subject { described_class.new(['--no-plugins', 'echo hello']) }

    it 'prints a response' do
      expect { subject.run }.to output(
        /hello/
      ).to_stdout
    end
  end
end
