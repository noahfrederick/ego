RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # Limits the available syntax to the non-monkey patched syntax that is
  # recommended. For more details, see:
  #   - http://rspec.info/blog/2012/06/rspecs-new-expectation-syntax/
  #   - http://www.teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
  #   - http://rspec.info/blog/2014/05/notable-changes-in-rspec-3/#zero-monkey-patching-mode
  config.disable_monkey_patching!

  # This setting enables warnings. It's recommended, but in some cases may
  # be too noisy due to issues in dependencies.
  config.warnings = true
end

# Get a new robot instance with plugin.
#
# @param plugin [String] basename of plugin script
# @return [Ego::Robot] the decorated robot instance
def robot_with_plugin(plugin)
  require 'ego'

  options = double('Ego::Options')
  opt_parser = double('OptionParser')

  allow(opt_parser).to receive_messages({
    program_name: 'ego',
  })

  allow(options).to receive_messages({
    robot_name: 'TestBot',
    verbose: false,
    usage: opt_parser,
  })

  robot = Ego::Robot.new(options)
  robot.extend(Ego::Printer) # Needed to test most robot output
  String.disable_colorization = true

  paths = Ego::Filesystem.builtin_plugins.select do |path|
    path.end_with?("/#{plugin}.rb")
  end

  Ego::Plugin.class_variable_set :@@plugins, {}
  Ego::Plugin.load paths
  Ego::Plugin.decorate(robot).ready
end

RSpec::Matchers.define :handle_query do |query|
  match do |robot|
    !robot.first_handler_for(query).nil?
  end
end

RSpec::Matchers.define :be_able_to do |desc|
  match do |robot|
    robot.capabilities.select do |capability|
      capability.desc == desc
    end.any?
  end
end
