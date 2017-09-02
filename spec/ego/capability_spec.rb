require 'ego/capability'

RSpec.describe Ego::Capability do
  let(:desc) { 'my desc' }
  let(:plugin) { double('Ego::Plugin') }
  subject { described_class.new(desc, plugin) }

  context 'on initization' do
    it 'sets its description' do
      expect(subject.desc).to eq(desc)
    end

    it 'sets its plug-in' do
      expect(subject.plugin).to be plugin
    end
  end

  describe '#to_s' do
    it 'returns the description' do
      expect(subject.to_s).to eq(desc)
    end
  end
end
