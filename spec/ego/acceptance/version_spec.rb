RSpec.describe 'bin/ego --version', type: :aruba do
  before(:each) { run_simple('bin/ego --version') }

  it 'prints version message' do
    expect(last_command_started.stdout).to match(/^ego v\d+\.\d+\.\d+/)
  end
end
