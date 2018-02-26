require 'spec_helper'
require 'puppet_rake_tasks/depchecker/resolver'

describe PuppetRakeTasks::DepChecker::Resolver do
  describe 'Create new resolver with default module_path' do
    it 'works' do
      result = described_class.new
      expect(result).not_to be_nil
    end
  end

  context 'puppet module tool items' do
    describe '#env' do
      it 'returns a puppet environment' do
        resolver = described_class.new
        result = resolver.env
        expect(result).to be_kind_of(Puppet::Node::Environment)
      end
    end

    describe '#modules' do
      let(:module_path) { File.join(FIXTURES_ROOT, 'tree') }

      it 'collects modules using moduletool' do
        resolver = described_class.new(module_path)
        result = resolver.modules
        expect(result).to be_kind_of(Puppet::ModuleTool::InstalledModules)
      end
    end
  end

  describe '#reset_caches' do
    let(:module_path) { File.join(FIXTURES_ROOT, 'tree') }
    let(:resolver) do
      resolver = described_class.new(module_path)
      resolver.instance_variable_set(:@env, :mock_env)
      resolver.instance_variable_set(:@modules, :mock_modules)
      resolver.instance_variable_set(:@incidents, :mock_incidents)
      resolver
    end

    it 'resets the env cache' do
      resolver.reset_caches
      expect(resolver.instance_variable_get(:@env)).to be_nil
    end
    it 'resets the modules cache' do
      resolver.reset_caches
      expect(resolver.instance_variable_get(:@modules)).to be_nil
    end
    it 'resets the incidents cache' do
      resolver.reset_caches
      expect(resolver.instance_variable_get(:@incidents)).to be_nil
    end
  end

  describe '#modulepath' do
    it 'returns array of paths' do
      resolver = described_class.new('/foo:/bar')
      result = resolver.modulepath
      expect(result).to match(['/foo', '/bar'])
    end
  end

  describe '#modulepath_s' do
    it 'return concatenated string of paths' do
      resolver = described_class.new(['/foo', '/bar'])
      result = resolver.modulepath_s
      expect(result).to match('/foo:/bar')
    end
  end

  describe '#modulepath=' do
    it 'splits strings' do
      resolver = described_class.new
      resolver.modulepath = '/foo:/bar'
      result = resolver.modulepath
      expect(result).to match(['/foo', '/bar'])
    end
    it 'assigns arrays' do
      resolver = described_class.new
      resolver.modulepath = ['/foo', '/bar']
      result = resolver.modulepath
      expect(result).to match(['/foo', '/bar'])
    end
  end
end
