# frozen_string_literal: true

require 'ego/robot'

RSpec.describe Ego::Robot, 'with fallback plug-in', plugin: 'fallback' do
  let(:unhandlable_query) { 'xxx' }
  let(:empty_query) { '' }

  it { should be_able_to 'help you write plug-ins' }

  it { should_not handle_query unhandlable_query }

  it 'prints a hint when a query is unhandled' do
    expect { subject.handle(unhandlable_query) }.to output(
      /^Ego\.plugin/
    ).to_stdout
  end

  it 'prints a hint containing the original query' do
    expect { subject.handle(unhandlable_query) }.to output(
      Regexp.new(unhandlable_query)
    ).to_stdout
  end

  it { should handle_query empty_query }

  it 'prints a message when the query is empty' do
    expect { subject.handle(empty_query) }.to output(
      /^(Yes|Hello|\.\.\.)\?$/
    ).to_stdout
  end
end
