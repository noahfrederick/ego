# Provide robot with plug-in loaded as test subject.
RSpec.shared_context 'robot with plug-in' do
  subject do |example|
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

    robot = described_class.new(options)

    with_plugin(robot, example.metadata[:plugin]).ready
  end
end

RSpec.configure do |config|
  # Set up the test subject when :plugin metadata is set.
  config.include_context 'robot with plug-in', :plugin
end

# Decorate object with plugin.
#
# @param obj [Object] the object to decorate
# @param plugin [String] basename of plugin script
# @return [Object] the decorated object
def with_plugin(obj, plugin)
  require 'ego'

  obj.extend(Ego::Printer) # Needed to test most robot output
  String.disable_colorization = true

  paths = Ego::Filesystem.builtin_plugins.select do |path|
    path.end_with?("/#{plugin}.rb")
  end

  Ego::Plugin.class_variable_set :@@plugins, {}
  Ego::Plugin.load paths
  Ego::Plugin.decorate(obj)
end

# Can the robot understand `query`?
RSpec::Matchers.define :handle_query do |query|
  match do |robot|
    !robot.first_handler_for(query).nil?
  end
end

# Does the robot have a capability matching `desc`?
RSpec::Matchers.define :be_able_to do |desc|
  match do |robot|
    robot.capabilities.select do |capability|
      capability.desc == desc
    end.any?
  end
end
