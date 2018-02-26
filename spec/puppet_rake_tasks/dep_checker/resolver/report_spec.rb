require 'spec_helper'
require 'puppet_rake_tasks/depchecker/report'

describe PuppetRakeTasks::DepChecker::Resolver::Report do
  describe '#report' do
    let(:resolver) { PuppetRakeTasks::DepChecker::Resolver.new }
    let(:filtered) do
      { 'foo' => [{ name: 'vstone/bar',
                    reason: :missing,
                    version_constraint: '> 0.0.1',
                    mod_details: { installed_version: nil } }] }
    end

    it 'outputs issues' do
      allow(resolver).to receive(:filtered) { filtered }
      expect { resolver.report }.to output(%r{^ERROR: module foo: missing dependency vstone/bar.}).to_stderr
    end

    it 'allows overriding output' do
      allow(resolver).to receive(:filtered) { filtered }
      expect do
        resolver.output = $stdout
        resolver.report
      end.to output(%r{^ERROR: module foo: missing dependency vstone/bar.}).to_stdout
    end

    it 'raises an exception with fail_on_error' do
      allow(resolver).to receive(:filtered) { filtered }
      resolver.fail_on_error = true
      expect do
        resolver.report
      end.to raise_error(PuppetRakeTasks::DepChecker::Resolver::Report::DependencyError)
    end
  end

  describe '#format_incident' do
    let(:reporter) do
      class Reporter
        include PuppetRakeTasks::DepChecker::Resolver::Report
      end.new
    end
    let(:incident) do
      {
        module_name: 'bar',
        name: 'vstone/foo',
        reason: :missing,
        version_constraint: '> 0.0.1',
        mod_details: { installed_version: nil }
      }
    end

    it 'formats a single incident' do
      expect do
        reporter.format_incident(incident)
      end.to output(%r{^ERROR: module bar: missing dependency vstone/foo.}).to_stderr
    end
    context 'custom format' do
      it 'is used' do
        expect do
          reporter.format = 'CUSTOM: %<module_name>s'
          reporter.format_incident(incident)
        end.to output('CUSTOM: bar' + "\n").to_stderr
      end

      it 'ignores missing values' do
        expect do
          reporter.format = 'CUSTOM: %<module_name>s %<key_does_not_exist>s'
          reporter.format_incident(incident)
        end.to output('CUSTOM: bar %<key_does_not_exist>s' + "\n").to_stderr
      end
    end
  end
end
