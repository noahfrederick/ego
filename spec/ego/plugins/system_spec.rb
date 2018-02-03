require 'ego/robot'

RSpec.describe Ego::Robot, 'with system plug-in', plugin: 'system' do
  it { should be_able_to 'execute system commands' }

  describe '#system' do
    let(:args) { ['foo', 'bar'] }

    before do
      allow(Kernel).to receive(:system).and_return(true)
      allow(subject).to receive(:debug)
      allow(subject).to receive(:alert)
    end

    it 'is defined' do
      expect(subject.respond_to?(:system)).to be true
    end

    it 'calls Kernel.system' do
      expect(Kernel).to receive(:system).with(*args)
      subject.system *args
    end

    it 'prints a debug message' do
      expect(subject).to receive(:debug).with(
        'Running system with arguments %s.',
        args
      )
      subject.system *args
    end

    it 'prints nothing on success' do
      expect(subject).not_to receive(:alert)
      subject.system *args
    end

    it 'prints an alert on error' do
      allow(Kernel).to receive(:system).with(*args).and_return(false)
      expect(subject).to receive(:alert).with(
        'Sorry, there was a problem running %s.',
        args.first
      )
      subject.system *args
    end
  end

  it { should be_able_to 'tell you your login name' }

  it { should handle_query 'what is my name' }
  it { should handle_query 'what is my user name' }
  it { should handle_query 'what is my username' }
  it { should handle_query 'what is my login name' }
  it { should handle_query 'what\'s my name' }
  it { should handle_query 'what\'s my user name' }
  it { should handle_query 'what\'s my username' }
  it { should handle_query 'what\'s my login name' }
  it { should handle_query 'who am I' }
  it { should handle_query 'who am I logged in as' }
  it { should_not handle_query 'what is your name' }
  it { should_not handle_query 'who are you' }

  it 'tells you your login name' do
    expect(subject).to receive(:system).with('who').and_return(true)
    expect { subject.handle('who am I') }.to output(
      <<~OUT
        You are currently logged in as:
      OUT
    ).to_stdout
  end
end
