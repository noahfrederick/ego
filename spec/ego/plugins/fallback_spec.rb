# frozen_string_literal: true

require 'ego/robot'

RSpec.describe Ego::Robot, 'with fallback plug-in', plugin: 'fallback' do
  let(:unhandlable_query) { 'xxx' }

  it { should be_able_to 'help you write plug-ins' }

  it { should_not handle_query :unhandlable_query }

  it 'prints a hint when a query is unhandled' do
    expect { subject.handle('xxx') }.to output(
      /^Ego\.plugin/
    ).to_stdout
  end

  it 'prints a hint containing the original query' do
    expect { subject.handle('xxx') }.to output(
      /xxx/
    ).to_stdout
  end
end
