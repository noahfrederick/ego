# frozen_string_literal: true

require 'ego/options'

RSpec.describe Ego::Options do
  it 'defaults to interpret-mode' do
    opts = described_class.new(['foo'])
    expect(opts.mode).to eq(:interpret)
  end

  it 'can be set to shell-mode' do
    opts = described_class.new(['-s'])
    expect(opts.mode).to eq(:shell)
  end

  it 'can be set to template-mode' do
    opts = described_class.new(['-t'])
    expect(opts.mode).to eq(:template)
  end

  it 'can be set to version-mode' do
    opts = described_class.new(['-v'])
    expect(opts.mode).to eq(:version)
  end

  it 'can be set to help-mode' do
    opts = described_class.new(['-h'])
    expect(opts.mode).to eq(:help)
  end

  it 'defaults to help-mode with no arguments' do
    opts = described_class.new([])
    expect(opts.mode).to eq(:help)
  end

  it 'defaults to loading user plug-ins' do
    opts = described_class.new(['foo'])
    expect(opts.plugins).to be true
  end

  it 'can be set to not load user plug-ins' do
    opts = described_class.new(['-n', 'foo'])
    expect(opts.plugins).to be false
  end

  it 'defaults to not verbose' do
    opts = described_class.new(['foo'])
    expect(opts.verbose).to be false
  end

  it 'can be set to verbose' do
    opts = described_class.new(['-V', 'foo'])
    expect(opts.verbose).to be true
  end

  it 'sets the query to remaining args join with spaces' do
    opts = described_class.new(%w[foo bar])
    expect(opts.query).to eq('foo bar')
  end

  it 'sets the robot name' do
    opts = described_class.new(['foo'])
    expect(opts.robot_name).to_not be_nil
  end

  it 'sets the usage' do
    opts = described_class.new(['foo'])
    expect(opts.usage).to be_instance_of OptionParser
  end

  it 'does not set a usage error normally' do
    opts = described_class.new(['foo'])
    expect(opts.usage_error).to be_nil
  end

  context 'with invalid option' do
    it 'sets a usage error message' do
      opts = described_class.new(['--does-not-exist'])
      expect(opts.usage_error).to eq('invalid option: --does-not-exist')
    end

    it 'sets help-mode' do
      opts = described_class.new(['--does-not-exist'])
      expect(opts.mode).to eq(:help)
    end
  end
end
