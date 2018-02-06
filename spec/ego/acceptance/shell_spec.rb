# frozen_string_literal: false

RSpec.describe 'bin/ego --shell', type: :aruba do
  before(:each) { run_command('bin/ego --shell') }

  it 'responds' do
    type('echo xxx')
    type('exit')
    expect(last_command_started).to have_output an_output_string_including('xxx')
  end
end
