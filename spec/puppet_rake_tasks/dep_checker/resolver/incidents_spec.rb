# -*- encoding: utf-8 -*-

require 'spec_helper'
require 'puppet_rake_tasks/depchecker/incidents'

describe PuppetRakeTasks::DepChecker::Resolver::Incidents do
  describe '#incidents' do
    context 'with issues present' do
      let(:module_path) { File.join(FIXTURES_ROOT, 'tree') }
      let(:resolver) { PuppetRakeTasks::DepChecker::Resolver.new(module_path) }
      it 'returns all incidents' do
        incidents = resolver.incidents
        expect(incidents).to include(
          'bar' => an_instance_of(Array),
          'foo' => an_instance_of(Array)
        )
      end
      it 'caches incidents' do
        allow(resolver).to receive(:initialize_incidents) { {} }
        resolver.incidents
        resolver.incidents
        expect(resolver).to have_received(:initialize_incidents).once
      end
    end
    context 'with no issues present' do
      let(:module_path) { File.join(FIXTURES_ROOT, 'clean') }
      let(:resolver) { PuppetRakeTasks::DepChecker::Resolver.new(module_path) }
      it 'returns an empty hash' do
        incidents = resolver.incidents
        expect(incidents).to match({})
      end
    end
  end
end
