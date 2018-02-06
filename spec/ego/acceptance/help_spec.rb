# frozen_string_literal: true

RSpec.describe 'bin/ego --help', type: :aruba do
  before(:each) { run_simple('bin/ego --help') }

  it 'prints usage help' do
    expect(last_command_started.stdout).to start_with 'Usage: ego'
  end
end
