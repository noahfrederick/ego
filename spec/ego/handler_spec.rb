require 'ego/handler'

RSpec.describe Ego::Handler do
  let(:condition) { ->(q) { 'bar' if q == 'foo' } }
  let(:regexp) { /^baz/i }
  let(:action) { ->(p) { puts p } }
  let(:priority) { 2 }
  subject { described_class.new(condition, action, priority) }

  context 'on initization' do
    it 'sets its condition' do
      expect(subject.condition).to be condition
    end

    it 'sets its action' do
      expect(subject.action).to be action
    end

    it 'sets its priority' do
      expect(subject.priority).to be priority
    end

    it 'defaults its priority to 5' do
      default_handler = described_class.new(condition, action)
      expect(default_handler.priority).to eq(5)
    end

    describe 'given something matchable as the condition' do
      it 'encloses it' do
        expect(regexp.respond_to?(:match)).to be true
        expect(regexp.respond_to?(:call)).to be false
        regexp_handler = described_class.new(regexp, action, priority)
        expect(regexp_handler.condition.respond_to?(:match)).to be false
        expect(regexp_handler.condition.respond_to?(:call)).to be true
      end
    end
  end

  it 'is comparable' do
    expect(subject.respond_to?(:'<=>')).to be true
  end

  it 'compares priorities' do
    handler1 = described_class.new(condition, action, 1)
    handler2 = described_class.new(condition, action, 2)
    expect(handler2).to be > handler1
    expect(handler1).to be < handler2
  end

  describe '#handle' do
    context 'when the query cannot be handled' do
      it 'returns false' do
        expect(subject.handle('fail')).to be false
      end
    end

    context 'when the query can be handled' do
      it 'returns the result of the condition closure' do
        expect(subject.handle('foo')).to eq('bar')
      end
    end
  end
end
