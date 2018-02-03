require 'ego/robot'

RSpec.describe Ego::Robot, 'with social plug-in', plugin: 'social' do
  it { should be_able_to 'socialize' }

  it { should handle_query 'who are you' }
  it { should handle_query 'what are you' }
  it { should handle_query 'what is your name' }
  it { should handle_query 'what\'s your name' }

  it 'prints its name' do
    expect { subject.handle('who are you') }.to output(
      /^(I'm TestBot|This is TestBot, a robot)\./
    ).to_stdout
  end

  it { should handle_query 'hello' }
  it { should handle_query 'salve' }
  it { should handle_query 'ave' }
  it { should handle_query 'hi' }
  it { should handle_query 'hey' }
  it { should handle_query 'ciao' }
  it { should handle_query 'hej' }

  it 'greets you' do
    expect { subject.handle('hello') }.to output(
      /^[[:upper:]].+\./
    ).to_stdout
  end
end
