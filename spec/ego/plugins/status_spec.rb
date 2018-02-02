require 'ego/robot'

RSpec.describe Ego::Robot, 'with status plug-in' do
  subject { robot_with_plugin('status') }

  it { should be_able_to 'report robot status' }

  it { should handle_query 'status' }
  it { should handle_query 'what is your status' }
  it { should handle_query 'diagnostic' }
  it { should handle_query 'diagnostics' }
  it { should handle_query 'do self-diagnostic' }
  it { should handle_query 'uptime' }
  it { should handle_query 'what is your uptime' }

  describe '#on_status' do
    it 'is defined' do
      expect(subject.respond_to?(:on_status)).to be true
    end

    it 'can be hooked into' do
      subject.on_status { print '--status--' }
      expect { subject.run_hook :on_status }.to output(/--status--/).to_stdout
    end
  end

  describe 'handler' do
    it 'runs the on_status hook' do
      allow(subject).to receive(:puts)
      allow(subject).to receive(:run_hook)

      expect(subject).to receive(:run_hook).with(:on_status)
      subject.handle('status')
    end

    it 'prints an emote' do
      allow(subject).to receive(:run_hook)

      expect { subject.handle('status') }.to output(
        <<~OUT
          *running self-diagnostics*
        OUT
      ).to_stdout
    end

    it 'prints robot uptime' do
      expect { subject.handle('status') }.to output(
        /uptime: \d+ seconds\n/
      ).to_stdout
    end

    it 'prints robot verbosity' do
      expect { subject.handle('status') }.to output(
        /verbosity: (normal|verbose)\n/
      ).to_stdout
    end
  end
end
