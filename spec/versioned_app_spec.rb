require 'spec_helper'

describe Phenotype::VersionedApp do
  describe "#add_strategy" do
    context "with no strategies" do
      subject { described_class.new }

      it "adds the strategy to the strategies" do
        subject.add_strategy("foo")
        expect(subject.strategies.size).to eql(1)
      end
    end

    context "with a starting strategy array" do
      subject { described_class.new(strategies: ["foo"]) }

      it "adds the strategy to the strategies" do
        subject.add_strategy("bar")
        expect(subject.strategies.size).to eql(2)
      end
    end
  end

  describe "#add_version" do
    subject { described_class.new }

    context "with a block" do
      before(:each) { subject.add_version(version: 'v1') { "foo" } }
      it "adds the block to routesets" do
        expect(subject.routes['v1'].call).to eql("foo")
      end
    end
  end

  describe "#call" do
    class MockStrategy
      def initialize(version)
        @version = version
      end

      def version(env)
        @version
      end
    end

    let(:env) { {'foo' => 'bar'}}

    context "with 0 strategies" do
        subject { described_class.new().call(env) }
        it 'returns a 406' do
          expect(subject[0]).to eql(406)
        end
     end

    context "with a single strategy" do
      subject { described_class.new(strategies: [MockStrategy.new('v1')]) }

      context "with a routeset that uses the version called in the strategy" do
        it "calls the routeset" do
          subject.add_version(version: 'v1') { "foo" }
          expect(subject.call(env)).to eql("foo")
        end
      end
    end

    context "with two strategies" do
      subject { described_class.new(strategies: [MockStrategy.new('v1'), MockStrategy.new('v1')]) }
        it "returns a 400" do
          expect(subject.call(env)[0]).to eql(400)
        end
    end
  end
end
