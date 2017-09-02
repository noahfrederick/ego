require 'ego/robot_error'

RSpec.describe Ego::RobotError do
  let(:msg) { 'error message' }
  subject { described_class.new(msg) }

  describe '#message' do
    it 'returns the error message' do
      expect(subject.message).to eq(msg)
    end
  end
end
