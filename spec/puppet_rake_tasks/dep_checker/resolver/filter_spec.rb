require 'spec_helper'
require 'puppet_rake_tasks/depchecker/filter'

RSpec::Matchers.define_negated_matcher :not_include, :include

describe PuppetRakeTasks::DepChecker::Resolver::Filter do
  describe '#filtered' do
    let(:module_path) { File.join(FIXTURES_ROOT, 'tree') }
    let(:resolver) { PuppetRakeTasks::DepChecker::Resolver.new(module_path) }

    it 'returns filtered incidents' do
      resolver.ignore(/.*/, name: 'vstone/foo')
      filtered = resolver.filtered
      expect(filtered).to include('foo' => a_kind_of(Array)).and not_include('bar')
    end
    it 'caches filtered incidents' do
      allow(resolver).to receive(:filter_incidents).and_return({})
      resolver.filtered
      resolver.filtered
      expect(resolver).to have_received(:filter_incidents).once
    end
  end

  describe '#filter_module_incidents' do
    let(:module_path) { File.join(FIXTURES_ROOT, 'tree') }
    let(:resolver) { PuppetRakeTasks::DepChecker::Resolver.new(module_path) }
    let(:ignores) { { 'bar' => [{ name: %r{vstone/.*} }] } }
    let(:incidents) do
      {
        'bar' => [
          { name: 'vstone/foo', reason: :foobar_reason },
          { name: 'puppetlabs/stdlib', reason: :version_mismatch }
        ]
      }
    end

    it 'filters incidents for a module' do
      allow(resolver).to receive(:ignores) { ignores }
      expect(resolver.send(:filter_module_incidents, 'bar', incidents['bar'])).to match(
        [{ name: 'puppetlabs/stdlib', reason: :version_mismatch }]
      )
    end
  end

  describe '#filter_incidents' do
    let(:resolver) { PuppetRakeTasks::DepChecker::Resolver.new }
    let(:ignores) { { 'bar' => [{ name: %r{vstone/.*} }] } }
    let(:incidents) do
      {
        'foo' => [],
        'bar' => [
          { name: 'vstone/foo', reason: :foobar_reason },
          { name: 'puppetlabs/stdlib', reason: :version_mismatch }
        ]
      }
    end

    it 'filters all incidents for all modules' do
      allow(resolver).to receive(:ignores) { ignores }
      allow(resolver).to receive(:incidents) { incidents }
      expect(resolver.send(:filter_incidents)).to match('bar' => [{ name: 'puppetlabs/stdlib', reason: :version_mismatch }])
    end
  end
end
