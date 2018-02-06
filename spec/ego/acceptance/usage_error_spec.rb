# frozen_string_literal: true

RSpec.describe 'bin/ego --invalid-flag', type: :aruba do
  before(:each) { run_command('bin/ego --invalid-flag', fail_on_error: false) }

  it 'exits with a non-zero status' do
    expect(last_command_started).not_to be_successfully_executed
  end

  it 'prints usage error' do
    expect(last_command_started).to have_output an_output_string_matching('^invalid option:')
  end

  it 'prints usage help' do
    expect(last_command_started).to have_output an_output_string_matching('^Usage: ego')
  end
end
