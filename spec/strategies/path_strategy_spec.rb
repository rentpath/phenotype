require 'spec_helper'

describe Phenotype::PathStrategy do
  describe '#version' do
    context 'with a version param' do
      subject { described_class.new }
      let(:env) { Rack::MockRequest.env_for('/v1/foo') }

      it 'returns with 1' do
        expect(subject.version(env)).to eql('1')
      end
    end

    context 'without a version param' do
      subject { described_class.new }
      let(:env) { Rack::MockRequest.env_for('/foo') }

      it 'returns with null strategy' do
        expect(subject.version(env)).to be_kind_of(Phenotype::NullStrategy)
      end
    end
  end
end
