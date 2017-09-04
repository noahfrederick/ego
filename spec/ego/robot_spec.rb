require 'ego/robot'

RSpec.describe Ego::Robot do
  let(:name) { 'TestBot' }
  let(:options) { double('Ego::Options') }
  let(:plugin) { double('Ego::Plugin') }
  subject do
    allow(options).to receive_messages({
      robot_name: name,
      verbose: false,
    })

    described_class.new(options)
  end

  context 'on initization' do
    it 'sets its name' do
      expect(subject.name).to eq(name)
    end

    it 'exposes the passed options object' do
      expect(subject.options).to be options
    end

    it 'has no capabilities' do
      expect(subject.capabilities).to be_empty
    end
  end

  describe '#on_ready' do
    it 'is defined' do
      expect(subject.respond_to?(:on_ready)).to be true
    end

    it 'can be hooked into' do
      subject.on_ready { print 'Ready!' }
      expect { subject.run_hook :on_ready }.to output('Ready!').to_stdout
    end
  end

  describe '#on_shutdown' do
    it 'is defined' do
      expect(subject.respond_to?(:on_shutdown)).to be true
    end

    it 'can be hooked into' do
      subject.on_shutdown { print 'Bye!' }
      expect { subject.run_hook :on_shutdown }.to output('Bye!').to_stdout
    end
  end

  describe '#ready' do
    it 'runs the on_ready hook' do
      subject.on_ready { print 'Ready!' }
      expect { subject.ready }.to output('Ready!').to_stdout
    end

    it 'is chainable' do
      expect(subject.ready).to be subject
    end
  end

  describe '#shutdown' do
    it 'runs the on_shutdown hook' do
      subject.on_shutdown { print 'Bye!' }
      expect { subject.shutdown }.to output('Bye!').to_stdout
    end
  end

  describe '#provide' do
    it 'is an alias for #define_singleton_method' do
      expect(subject.respond_to?(:foo)).to be false
      subject.provide(:foo) { :bar }
      expect(subject.respond_to?(:foo)).to be true
      expect(subject.foo).to eq(:bar)
    end
  end

  describe '#can' do
    context 'without a plug-in context set' do
      it 'fails' do
        expect { subject.can('fail') }.to raise_error(Ego::RobotError)
      end
    end

    context 'with a plug-in context set' do
      let(:plugin_name) { 'my_plug' }
      before do
        allow(plugin).to receive(:name) { plugin_name }
        subject.context = plugin
      end

      it 'adds a capability' do
        expect(subject.capabilities).to be_empty
        subject.can('succeed')
        expect(subject.capabilities).not_to be_empty
      end

      it 'sets the capability description' do
        subject.can('succeed')
        expect(subject.capabilities.last.desc).to eq('succeed')
      end

      it 'records the plug-in with the capability' do
        subject.can('succeed')
        expect(subject.capabilities.last.plugin.name).to eq(plugin_name)
      end
    end
  end

  describe '#on' do
    context 'given a single condition' do
      let(:condition) { /^some condition/i }
      let(:priority) { 9 }

      before do
        subject.on(condition, priority) { }
      end

      it 'passes the condition and action to a new handler' do
        expect(subject.instance_variable_get(:@handlers).count).to eq(1)
        expect(subject.instance_variable_get(:@handlers).last).to be_instance_of(Ego::Handler)
      end

      it 'passes the condition and action to a new handler with a priority' do
        expect(subject.instance_variable_get(:@handlers).count).to eq(1)
        expect(subject.instance_variable_get(:@handlers).last.priority).to eq(priority)
      end
    end

    context 'given a hash' do
      before do
        subject.on(
          ->(q) { 'foo' } => 1,
          ->(q) { 'bar' } => 2,
        ) { }
      end

      it 'creates a new handler for each item' do
        expect(subject.instance_variable_get(:@handlers).count).to eq(2)
      end

      it 'uses the keys as conditions' do
        expect(subject.instance_variable_get(:@handlers).first.condition.call('')).to eq('foo')
      end

      it 'uses the values as priorities' do
        expect(subject.instance_variable_get(:@handlers).first.priority).to eq(1)
      end
    end

    context 'given no action block' do
      it 'raises an error' do
        expect { subject.on(:foo) }.to raise_error(Ego::RobotError)
      end
    end
  end

  describe '#run_action' do
    it 'calls the action with supplied parameters' do
      expect(subject.run_action(->(params) { params }, 'foo')).to eq('foo')
    end

    it 'executes the action in the context of the robot instance' do
      expect(subject.run_action(->(params) { name }, 'foo')).to eq(subject.name)
    end
  end

  describe '#before_action' do
    it 'is defined' do
      expect(subject.respond_to?(:before_action)).to be true
    end

    it 'can be hooked into' do
      subject.before_action { print 'Before!' }
      expect { subject.run_hook :before_action }.to output('Before!').to_stdout
    end

    it 'is run by #run_action' do
      subject.before_action { print 'Before!' }
      expect { subject.run_action(->(p) { true }, 'p') }.to output('Before!').to_stdout
    end

    it 'receives the action and action parameters' do
      subject.before_action { |action, params| print params }
      expect { subject.run_action(->(p) { true }, 'p') }.to output('p').to_stdout
    end
  end

  describe '#after_action' do
    it 'is defined' do
      expect(subject.respond_to?(:after_action)).to be true
    end

    it 'can be hooked into' do
      subject.after_action { print 'After!' }
      expect { subject.run_hook :after_action }.to output('After!').to_stdout
    end

    it 'is run by #run_action' do
      subject.after_action { print 'After!' }
      expect { subject.run_action(->(p) { 'out' }, 'p') }.to output('After!').to_stdout
    end

    it 'receives the action, parameters, and return value' do
      subject.after_action { |action, params, result| print result + params }
      expect { subject.run_action(->(p) { 'out' }, 'p') }.to output('outp').to_stdout
    end
  end

  describe '#handle' do
    before do
      subject.on(
        ->(q) { :three if 'bar'.match(q) } => 3,
        ->(q) { :two if 'foo'.match(q) } => 2,
        ->(q) { :one if 'foo'.match(q) } => 1,
      ) { |params| params }
    end

    it 'chooses the highest-priority handler that matches the query' do
      expect(subject.handle('foo')).to eq(:two)
    end

    it 'returns false when no handlers match' do
      expect(subject.handle('xxx')).to be false
    end
  end

  describe '#before_handle_query' do
    it 'is defined' do
      expect(subject.respond_to?(:before_handle_query)).to be true
    end

    it 'can be hooked into' do
      subject.before_handle_query { print 'Before!' }
      expect { subject.run_hook :before_handle_query }.to output('Before!').to_stdout
    end

    it 'is run by #handle' do
      subject.before_handle_query { print 'Before!' }
      expect { subject.handle('xxx') }.to output('Before!').to_stdout
    end

    it 'receives the query' do
      subject.before_handle_query { |query| print query }
      expect { subject.handle('xxx') }.to output('xxx').to_stdout
    end
  end

  describe '#on_unhandled_query' do
    before do
      subject.on_unhandled_query { print 'Oops!' }
    end

    it 'is defined' do
      expect(subject.respond_to?(:on_unhandled_query)).to be true
    end

    it 'can be hooked into' do
      expect { subject.run_hook :on_unhandled_query }.to output('Oops!').to_stdout
    end

    it 'is run by #handle when no handlers match' do
      expect { subject.handle('xxx') }.to output('Oops!').to_stdout
    end

    it 'is not run by #handle when the query is handled' do
      subject.on('xxx') { }
      expect { subject.handle('xxx') }.not_to output('Oops!').to_stdout
    end

    it 'receives the query' do
      subject.on_unhandled_query { |query| print query }
      expect { subject.handle('xxx') }.to output('Oops!xxx').to_stdout
    end
  end
end
