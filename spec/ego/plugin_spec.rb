require 'ego/plugin'

RSpec.describe Ego::Plugin do
  let(:name) { 'my_plug' }
  let(:body) { proc { true } }
  let(:plugin) { described_class.new(name, body) }
  let(:builtin_plugin) { described_class.new(name, body, builtin: true) }

  context 'on initization' do
    it 'sets its name' do
      expect(plugin.name).to eq(name)
    end

    it 'sets its body' do
      expect(plugin.body).to be body
    end

    it 'sets its builtin flag' do
      expect(builtin_plugin.builtin).to be true
    end

    it 'defaults its builtin flag to false' do
      expect(plugin.builtin).to be false
    end
  end

  describe '.register' do
    it 'returns a new plugin' do
      expect(described_class.register(name, body)).to be_instance_of(described_class)
    end
  end


  describe '.decorate' do
    let(:obj) do
      Class.new { attr_accessor :context, :a, :b }.new
    end

    before do
      described_class.class_variable_set :@@plugins, {}
      described_class.class_variable_set :@@context, nil
      described_class.register('a', proc { |obj|
        obj.a = 'foo'
      })
      described_class.register('b', proc { |obj|
        obj.b = 'bar'
      })
    end

    it 'sets self.context to each registered plugin' do
      described_class.register('c', proc { |obj|
        obj.context = described_class.context
      })
      described_class.decorate(obj)
      expect(obj.context).to be_instance_of(described_class)
    end

    it 'sets resets self.context to nil' do
      expect(described_class.context).to be_nil
      described_class.decorate(obj)
      expect(described_class.context).to be_nil
    end

    it 'calls each plugin body passing the obj' do
      expect(obj).to receive_messages({
        :a= => 'foo',
        :b= => 'bar',
      })
      described_class.decorate(obj)
    end

    it 'returns the decorated obj' do
      decorated = described_class.decorate(obj)
      expect(decorated.a).to eq('foo')
      expect(decorated.b).to eq('bar')
    end
  end
end
