require 'spec_helper'

describe Phenotype::ParamStrategy do
  describe "#get_version" do
    context "with a version param" do
      subject { described_class.new }
      let(:env){ Rack::MockRequest.env_for('/foo?v=v1')}

      it "returns with v1" do
        expect(subject.get_version(env)).to eql("v1")
      end
    end

    context "without a version param" do
      subject { described_class.new }
      let(:env){ Rack::MockRequest.env_for('/foo')}

      it "returns with nil" do
        expect(subject.get_version(env)).to be_nil
      end

    end
  end
end
