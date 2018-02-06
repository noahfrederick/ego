# frozen_string_literal: true

RSpec.describe 'bin/ego --template', type: :aruba do
  context 'without a query' do
    before(:each) { run_simple('bin/ego --template') }

    it 'prints the plug-in template with default query' do
      # rubocop:disable Layout/EmptyLinesAroundArguments
      expect(last_command_started.stdout).to eq(
        <<~TEMPLATE
          Ego.plugin do |robot|
            robot.can 'do something new'

            robot.on(/^My new plugin$/i) do |params|
              alert 'Not implemented yet. Go ahead and edit ~/.config/ego/plugins/my_new_plugin.rb.'
            end
          end
        TEMPLATE
      )
      # rubocop:enable Layout/EmptyLinesAroundArguments
    end
  end

  context 'with a query' do
    before(:each) { run_simple('bin/ego --template help me out') }

    it 'prints the plug-in template with supplied query' do
      # rubocop:disable Layout/EmptyLinesAroundArguments
      expect(last_command_started.stdout).to eq(
        <<~TEMPLATE
          Ego.plugin do |robot|
            robot.can 'do something new'

            robot.on(/^help me out$/i) do |params|
              alert 'Not implemented yet. Go ahead and edit ~/.config/ego/plugins/help_me_out.rb.'
            end
          end
        TEMPLATE
      )
      # rubocop:enable Layout/EmptyLinesAroundArguments
    end
  end
end
