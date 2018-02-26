require 'spec_helper'
require 'puppet_rake_tasks/depchecker/ignores'

describe PuppetRakeTasks::DepChecker::Resolver::Ignores do
  describe '#ignores=' do
    let(:module_path) { File.join(FIXTURES_ROOT, 'tree') }
    let(:resolver) { PuppetRakeTasks::DepChecker::Resolver.new(module_path) }

    it 'sets the ignore rules' do
      resolver.ignores = 'foobar'
      expect(resolver.ignores).to match('foobar')
    end

    it 'clears the cached ignored_for_modules' do
      resolver.ignores = { 'bar' => [{ name: 'foobar' }] }
      resolver.ignores_for_module('bar')
      resolver.ignores = { 'foo' => [] }
      expect(resolver.ignores_for_module('bar')).to match([])
    end
  end

  describe '#ignore' do
    let(:resolver) { PuppetRakeTasks::DepChecker::Resolver.new }

    it 'adds a new ignore rule' do
      resolver.ignore 'bar', name: 'foobar'
      expect(resolver.ignores_for_module('bar')).to match([{ name: 'foobar' }])
    end

    it 'clears the cached value for that module' do
      allow(resolver).to receive(:collect_ignores_for_module)
      resolver.ignores = { 'bar' => [{ name: 'foobar' }] }
      resolver.ignores_for_module('bar')
      resolver.ignore 'bar', name: 'foo'
      expect(resolver.instance_variable_get('@ignores_for_module')['bar']).to be_nil
    end
  end

  describe '#ignores' do
    let(:resolver) { PuppetRakeTasks::DepChecker::Resolver.new }

    it 'returns configured ignores' do
      resolver.ignores = { 'bar' => [{ name: 'foobar' }] }
      expect(resolver.ignores).to match('bar' => [{ name: 'foobar' }])
    end
  end

  describe '#ignores_for_module' do
    let(:resolver) { PuppetRakeTasks::DepChecker::Resolver.new }

    it 'returns configured ignores for a module' do
      resolver.ignores = { 'bar' => [], 'foo' => [{ name: 'bar' }, { other: /.*/ }] }
      expect(resolver.ignores_for_module('foo')).to match([{ name: 'bar' }, { other: /.*/ }])
    end
    it 'uses the cached ignore rules for the module' do
      allow(resolver).to receive(:collect_ignores_for_module).and_return({})
      resolver.ignores_for_module('foo')
      resolver.ignores_for_module('foo')
      expect(resolver).to have_received(:collect_ignores_for_module).once
    end
  end

  describe '#ignore_matches_incident' do
    let(:resolver) { PuppetRakeTasks::DepChecker::Resolver.new }
    let(:incident) do
      {
        name: 'vstone/foo',
        reason: :version_mismatch,
        version_contstraint: '~> 1.0.0 < 2.0.0',
        parent: { name: 'vstone/bar', version: 'v1.0.0' },
        mod_details: { installed_version: '1.0.0' }
      }
    end

    before do
      resolver.ignores = {}
    end

    context 'returns false if there are no ignore rules' do
      let(:resolver) { PuppetRakeTasks::DepChecker::Resolver.new }

      it do
        expect(resolver.ignores_matches_incident('foo', incident)).to match(false)
      end
    end

    context 'returns true if an ignore rule matches' do
      it 'by name only' do
        resolver.ignore 'bar', name: 'vstone/foo'
        expect(resolver.ignores_matches_incident('bar', incident)).to match(true)
      end

      [:version_mismatch, 'version_mismatch'].each do |reason|
        it "with reason as a #{reason.class}" do
          resolver.ignore 'bar', reason: reason
          expect(resolver.ignores_matches_incident('bar', incident)).to match(true)
        end
      end
    end

    it 'returns false if no ignore rule matches' do
      resolver.ignore 'bar', reason: :no_reason
      expect(resolver.ignores_matches_incident('bar', incident)).to match(false)
    end

    context 'ignore-rules with regexes' do
      it 'matches modulenames' do
        resolver.ignore 'bar', name: %r{vstone/.*}
        expect(resolver.ignores_matches_incident('bar', incident)).to match(true)
      end
      it 'matches incident values' do
        resolver.ignore 'bar', reason: /.*/
        expect(resolver.ignores_matches_incident('bar', incident)).to match(true)
      end
    end
  end
end
