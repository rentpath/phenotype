require 'spec_helper'

describe Phenotype::NullStrategy do
  let(:env) { Rack::MockRequest.env_for('/foo') }
  subject { described_class.new }
  describe "#get_version" do
    it "returns nil" do
      expect(subject.get_version(env)).to be_nil
    end
  end
end
