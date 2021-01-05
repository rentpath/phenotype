# frozen_string_literal: true

require 'spec_helper'

describe Phenotype::HeaderStrategy do
  describe '#version' do
    context 'with dynamic header' do
      let(:env) do
        env = Rack::MockRequest.env_for('/foo')
        env['HTTP_VERSION'] = 'v1'
        env
      end

      subject { described_class.new(header: 'version') }

      it 'returns correct version' do
        expect(subject.version(env)).to eql('v1')
        env['HTTP_VERSION'] = 'v2'
        expect(subject.version(env)).to eql('v2')
      end
    end

    context 'with no header' do
      let(:env) do
        Rack::MockRequest.env_for('/foo')
      end

      subject { described_class.new(header: 'Sue') }

      it 'returns with nil' do
        expect(subject.version(env)).to be_kind_of Phenotype::NullStrategy
      end
    end
  end
end
