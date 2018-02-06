# frozen_string_literal: true

RSpec.describe 'bin/ego', type: :aruba do
  before(:each) { run_command('bin/ego') }

  it 'prints usage help' do
    expect(last_command_started).to have_output an_output_string_matching('^Usage: ego')
  end
end
