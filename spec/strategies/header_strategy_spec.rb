require 'spec_helper'

describe Phenotype::HeaderStrategy do
  describe "#get_version" do
    context "with the right header" do
      let(:env) do
        env = Rack::MockRequest.env_for('/foo')
        env['HTTP_SUE'] = 'v1'
        env
      end

      subject { described_class.new(header: 'Sue') }

      it "returns with v1" do
        expect(subject.get_version(env)).to eql("v1")
      end
    end

    context "with no header" do
      let(:env) do
        Rack::MockRequest.env_for('/foo')
      end

      subject { described_class.new(header: 'Sue') }

      it "returns with nil" do
        expect(subject.get_version(env)).to be_nil
      end
    end
  end
end
