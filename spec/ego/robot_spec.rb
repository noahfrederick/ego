require 'ego/robot'

RSpec.describe Ego::Robot do
  it 'sets its name' do
    formatter = double('Ego::Formatter')
    options = double('Ego::Options')
    allow(options).to receive(:verbose)
    expect(options).to receive_messages(robot_name: 'foo')

    robot = Ego::Robot.new(options, formatter)
    expect(robot.name).to eq('foo')
  end

  describe '#debug' do
    context 'in non-verbose mode' do
      before(:example) do
        @options = double('Ego::Options')
        allow(@options).to receive_messages(robot_name: 'foo', verbose: false)
        @formatter = double('Ego::Formatter')
      end

      it 'does nothing' do
        expect(@formatter).not_to receive(:debug)
        robot = Ego::Robot.new(@options, @formatter)
        robot.debug 'foo'
      end
    end

    context 'in verbose mode' do
      before(:example) do
        @options = double('Ego::Options')
        allow(@options).to receive_messages(robot_name: 'foo', verbose: true)
        @formatter = double('Ego::Formatter')
      end

      it 'passes the message to the formatter' do
        expect(@formatter).to receive(:debug).with('foo')
        robot = Ego::Robot.new(@options, @formatter)
        robot.debug 'foo'
      end
    end
  end
end
