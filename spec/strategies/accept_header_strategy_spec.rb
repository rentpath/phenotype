require "spec_helper"

describe Phenotype::AcceptHeaderStrategy do
  describe "#get_version" do
    subject { described_class.new }

    context "with the version as the only accept header" do
      let(:env) do
        env = Rack::MockRequest.env_for('/foo')
        env['HTTP_ACCEPT'] = 'application/vnd.rentpath.api+json;version=1'
        env
      end

      it "returns the correct version" do
        expect(subject.get_version(env)).to eql('1')
        env['HTTP_ACCEPT'] = 'application/vnd.rentpath.api+json;version=2'
        expect(subject.get_version(env)).to eql("2")
      end
    end

    context "with no accept header" do
      let(:env) do
        Rack::MockRequest.env_for('/foo')
      end

      it 'returns nil ' do
        expect(subject.get_version(env)).to be_nil
      end
    end

    context "with an accept header without the expected values" do
      let(:env) do
        env = Rack::MockRequest.env_for('/foo')
        env['HTTP_ACCEPT'] = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8'
        env
      end

      it 'returns nil ' do
        expect(subject.get_version(env)).to be_nil
      end
    end
  end
end
