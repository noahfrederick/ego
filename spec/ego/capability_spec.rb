require 'ego/capability'

RSpec.describe Ego::Capability do
  let(:desc) { 'my desc' }
  let(:plugin) { double('Ego::Plugin') }

  describe '#initialize' do
    it 'sets its description' do
      allow(Ego::Plugin).to receive(:context) { plugin }
      subject = described_class.new(desc)
      expect(subject.desc).to eq(desc)
    end

    it 'sets the plug-in context' do
      allow(Ego::Plugin).to receive(:context) { plugin }
      subject = described_class.new(desc)
      expect(subject.plugin).to be plugin
    end
  end

  describe '#to_s' do
    it 'returns the description' do
      subject = described_class.new(desc)
      expect(subject.to_s).to eq(desc)
    end
  end
end
