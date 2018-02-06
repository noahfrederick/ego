# frozen_string_literal: true

RSpec.describe 'bin/ego --version', type: :aruba do
  before(:each) { run_command('bin/ego --version') }

  it 'prints version message' do
    expect(last_command_started).to have_output an_output_string_matching('^ego v\d+\.\d+\.\d+')
  end
end
