# -*- encoding: utf-8 -*-

require 'spec_helper'
require 'puppet_rake_tasks/depchecker'

describe PuppetRakeTasks::DepChecker::Task do
  describe '#new' do
    it 'creates a new rake task' do
      described_class.new
      expect(Rake::Task[:depcheck]).not_to be_nil
    end
    context 'with a name passed to the constructor' do
      let(:task) { described_class.new(:task_name) }
      it 'correctly sets the name' do
        expect(task.name).to eq :task_name
      end
    end

    it 'allow configuration' do
      expect(described_class.new do |c|
        c.modulepath = ['foobar']
      end.depchecker.modulepath).to eq ['foobar']
    end
  end
end
