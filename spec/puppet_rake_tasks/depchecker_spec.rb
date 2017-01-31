# -*- encoding: utf-8 -*-

require 'spec_helper'
require 'puppet_rake_tasks/depchecker'

describe PuppetRakeTasks::DepChecker::Task do

  describe '#new' do
    it 'creates a new rake task' do
      PuppetRakeTasks::DepChecker::Task.new
      expect(Rake::Task[:depcheck]).not_to be_nil
    end

    it 'allow configuration' do
      PuppetRakeTasks::DepChecker::Task.new do |c|
        c.modulepath = ['foobar']
      end
      expect(Rake::Task[:depcheck]).not_to be_nil
    end
  end


end
