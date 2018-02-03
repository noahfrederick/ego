require 'ego/robot'

RSpec.describe Ego::Robot, 'with capabilities plug-in', plugin: 'capabilities' do
  describe '#understand?' do
    it 'is defined on the robot instance' do
      expect(subject.respond_to?(:understand?)).to be true
    end

    it 'returns false for queries the robot cannot handle' do
      expect(subject.understand?('xxx')).to be false
    end

    it 'returns true for queries the robot can handle' do
      subject.on(/^zzz$/) { }
      expect(subject.understand?('zzz')).to be true
    end
  end

  it { should be_able_to 'list capabilities' }

  it { should handle_query 'list what you can do' }
  it { should handle_query 'list handlers' }
  it { should handle_query 'show me handlers' }
  it { should handle_query 'show me what you can do' }
  it { should handle_query 'show me what queries you understand' }
  it { should handle_query 'show me what queries you can understand' }
  it { should handle_query 'tell me what you can do' }
  it { should handle_query 'tell me what you are able to do' }
  it { should handle_query 'tell me what you can understand' }
  it { should handle_query 'tell me what queries you can understand' }
  it { should handle_query 'help' }
  it { should handle_query 'help me' }
  it { should handle_query 'what can you do' }
  it { should handle_query 'what can you understand' }
  it { should handle_query 'what are you able to do' }
  it { should handle_query 'what do you do' }
  it { should handle_query 'what do you understand' }
  it { should handle_query 'what are you able to handle' }

  it 'prints list of capabilities' do
    expect { subject.handle('help') }.to output(
      <<~OUT
        I can...
        - list capabilities (capabilities*)
      OUT
    ).to_stdout
  end

  it { should handle_query 'can you understand x' }
  it { should handle_query 'can you understand x?' }
  it { should handle_query 'do you understand x' }
  it { should handle_query 'would you understand x' }
  it { should_not handle_query 'do you understand' }
  it { should_not handle_query 'do you understand?' }

  it 'prints a message when it can understand' do
    expect { subject.handle('do you understand can you understand x') }.to output(
      <<~OUT
        Yes, I understand that.
      OUT
    ).to_stdout
  end

  it 'prints a message when it can not understand' do
    expect { subject.handle('do you understand xxx') }.to output(
      <<~OUT
        No, I do not understand that.
      OUT
    ).to_stdout
  end
end
