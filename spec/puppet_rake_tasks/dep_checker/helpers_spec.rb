# -*- encoding: utf-8 -*-
require 'spec_helper'
require 'puppet_rake_tasks/depchecker/helpers'

describe PuppetRakeTasks::DepChecker::Helpers do
  describe '.normalize_path' do
    it 'converts an string to array' do
      result = described_class.normalize_path('foo:bar')
      expect(result).to match(%w(foo bar))
    end
    it 'flattens an array' do
      result = described_class.normalize_path(['foo', %w(bar foobar)])
      expect(result).to match(%w(foo bar foobar))
    end
  end

  describe '.compare_values' do
    context 'if the first argument is a regex' do
      it 'returns true if it matches' do
        result = described_class.compare_values(/^foo/, 'foobar')
        expect(result).to match(true)
      end
      it 'returns false if it does not match' do
        result = described_class.compare_values(/^bar/, 'foobar')
        expect(result).to match(false)
      end
      it 'converts the second argument to a string' do
        result = described_class.compare_values(/^12/, 123)
        expect(result).to match(true)
      end
    end
    context 'symbol arguments' do
      it 'returns true if both equal symbols' do
        result = described_class.compare_values(:foo, :foo)
        expect(result).to match(true)
      end
      it 'returns true if first value is a string' do
        result = described_class.compare_values('foo', :foo)
        expect(result).to match(true)
      end
      it 'returns true if second value is a string' do
        result = described_class.compare_values(:foo, 'foo')
        expect(result).to match(true)
      end
      it 'returns false if they dont match' do
        result = described_class.compare_values(:foo, :bar)
        expect(result).to match(false)
      end
    end
    context 'other arguments' do
      it 'returns true if it matches' do
        result = described_class.compare_values(1, 1)
        expect(result).to match(true)
      end
      it 'returns false if it does not match' do
        result = described_class.compare_values('no', false)
        expect(result).to match(false)
      end
    end
  end
end
