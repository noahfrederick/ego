require 'ego/plugin_helper'

RSpec.describe Ego::PluginHelper do
  let(:query) { 'Do something new!' }
  let(:program_name) { 'ego' }
  subject { described_class.new(query: query, program_name: program_name) }

  describe '#slug' do
    it 'slugifies the query' do
      expect(subject.slug).to eq('do_something_new')
    end
  end

  describe '#path' do
    it 'returns a path to the plugins directory' do
      expect(subject.path).to match(/\/plugins\//)
    end

    it 'uses a tilde for the home directory' do
      expect(subject.path).to match(/^~\//)
    end

    it 'names the file after the slug' do
      expect(subject.path).to match(subject.slug)
    end

    it 'appends an extension' do
      expect(subject.path).to match(/\.rb$/)
    end
  end

  describe '#hint' do
    it 'contains the original query' do
      expect(subject.hint).to match(query)
    end

    it 'contains the program name followed by the shell-escaped query' do
      expect(subject.hint).to match(/ego Do\\ something\\ new\\! > /)
    end

    it 'contains the suggested plug-in path' do
      expect(subject.hint).to match(subject.path)
    end
  end

  describe '#template' do
    it 'contains ruby code to bootstrap a new plug-in' do
      expect(subject.template).to match(/^Ego\.plugin do \|robot\|/)
    end

    it 'contains the original query as a regex' do
      expect(subject.template).to match(query)
    end

    it 'suggests editing the plug-in path' do
      expect(subject.template).to match("edit #{subject.path}")
    end
  end
end
