require 'ego/robot'

RSpec.describe Ego::Robot, 'with robot_io plug-in' do
  subject { robot_with_plugin('robot_io') }

  it { should be_able_to 'output text to the terminal' }

  describe '#verbose?' do
    it 'is defined on the robot instance' do
      expect(subject.respond_to?(:verbose?)).to be true
    end
  end

  it { should be_able_to 'repeat what you say' }

  it { should handle_query 'say hello' }
  it { should handle_query 'echo hello' }
  it { should_not handle_query 'whatever you say' }
  it { should_not handle_query 'there is an echo in here' }

  it 'prints the input' do
    expect { subject.handle('say hello, robot') }.to output(
      <<~OUT
        hello, robot
      OUT
    ).to_stdout
  end
end
