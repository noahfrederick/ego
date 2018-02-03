RSpec.describe 'bin/ego hello', type: :aruba do
  before(:each) { run_simple('bin/ego hello') }

  it 'responds with a greeting' do
    expect(last_command_started.stdout).to match(/^[[:upper:]].+\./)
  end
end
