RSpec.describe 'bin/ego --invalid-flag', type: :aruba do
  before(:each) { run_simple('bin/ego --invalid-flag', fail_on_error: false) }

  it 'exits with a non-zero status' do
    expect(last_command_started).not_to be_successfully_executed
  end

  it 'prints usage error' do
    expect(last_command_started.stderr).to start_with 'invalid option:'
  end

  it 'prints usage help' do
    expect(last_command_started.stdout).to start_with 'Usage: ego'
  end
end
