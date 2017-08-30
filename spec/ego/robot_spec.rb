require 'ego/robot'

RSpec.describe Ego::Robot do
  it 'sets its name' do
    options = double('Ego::Options')
    allow(options).to receive(:verbose)
    expect(options).to receive_messages(robot_name: 'foo')

    robot = Ego::Robot.new(options)
    expect(robot.name).to eq('foo')
  end

  describe '#debug' do
    context 'in non-verbose mode' do
      before(:example) do
        @options = double('Ego::Options')
        allow(@options).to receive_messages(robot_name: 'foo', verbose: false)
      end

      it 'does nothing' do
        robot = Ego::Robot.new(@options)
        expect { robot.debug('foo') }.not_to output.to_stderr
      end
    end

    context 'in verbose mode' do
      before(:example) do
        @options = double('Ego::Options')
        allow(@options).to receive_messages(robot_name: 'foo', verbose: true)
      end

      it 'prints the message to STDERR' do
        robot = Ego::Robot.new(@options)
        expect { robot.debug('foo') }.to output.to_stderr
      end
    end
  end

  describe '#verbose?' do
    context 'in non-verbose mode' do
      before(:example) do
        @options = double('Ego::Options')
        allow(@options).to receive_messages(robot_name: 'foo', verbose: false)
      end

      it 'returns false' do
        robot = Ego::Robot.new(@options)
        expect(robot.verbose?).to be false
      end
    end

    context 'in verbose mode' do
      before(:example) do
        @options = double('Ego::Options')
        allow(@options).to receive_messages(robot_name: 'foo', verbose: true)
      end

      it 'returns true' do
        robot = Ego::Robot.new(@options)
        expect(robot.verbose?).to be true
      end
    end
  end
end
