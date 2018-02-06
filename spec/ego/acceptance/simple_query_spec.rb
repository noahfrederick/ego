# frozen_string_literal: true

RSpec.describe 'bin/ego hello', type: :aruba do
  before(:each) { run_command('bin/ego hello') }

  it 'responds with a greeting' do
    expect(last_command_started).to have_output an_output_string_matching('^[[:upper:]].+\.$')
  end
end
