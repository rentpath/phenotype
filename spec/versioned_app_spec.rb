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
    let(:default) { false }

    context "with a block" do
      before(:each) { subject.add_version(version: 'v1', default: default) { "foo" } }
      it "adds the block to routesets" do
        expect(subject.routes['v1'].call).to eql("foo")
      end

      context "with default false" do

        it "doesn't add the block to default" do
          expect(subject.default_routes.call).not_to eql("foo")
        end
      end

      context "with default true" do
        let(:default) { true } 

        it "adds the block to default" do
          expect(subject.default_routes.call).to eql("foo")
        end

        it "overwrites the current default" do
          subject.add_version(version: 'v1', default: default) { "bar" } 
          expect(subject.default_routes.call).to eql("bar")
        end
      end
    end
  end

  describe "#call" do
    class MockStrategy
      attr_accessor :version
      def initialize(version)
        @version = version
      end

      def get_version(env)
        version
      end
    end
    let(:env) { {'foo' => 'bar'}}

    context "with 0 strategies" do
      context "and no default routesets" do
        subject { described_class.new().call(env) }
        it 'returns a 404' do
          expect(subject[0]).to eql(404)
        end
      end
      
      context "and a default routeset" do
        subject do 
          foo = described_class.new()
          foo.add_version('v1', default: true) { "foo" }
        end
      end

    end

    context "with a single strategy" do
      subject { described_class.new(strategies: [MockStrategy.new('v1')]) }
      context "and no default routesets" do

        it "returns a 404" do
          expect(subject.call(env)[0]).to eql(404)
        end
      end

      context "with a default routeset using a different version that the strategy" do
        it "calls the default" do
          subject.add_version(version: 'v2', default:true) { "foo" }
          expect(subject.call(env)).to eql("foo")
        end
      end

      context "with a routeset that uses the version called in the strategy" do
        it "calls the routeset" do
          subject.add_version(version: 'v1') { "foo" }
          expect(subject.call(env)).to eql("foo")
        end
      end
    end

    context "with two strategies" do
      subject { described_class.new(strategies: [MockStrategy.new('v1'), MockStrategy.new('v1')]) }
      context "and no default routesets" do
        it "returns a 404" do
          expect(subject.call(env)[0]).to eql(404)
        end
      end

      context "and a default routeset using a different version than the strategy" do
        it "calls the default routeset" do
          subject.add_version(version: 'v2', default:true) { "foo" }
          expect(subject.call(env)).to eql("foo")
        end
      end

      context "with a routeset that uses the version called in the strategy" do
        it "calls the routeset" do
          subject.add_version(version: 'v1') { "foo" }
          expect(subject.call(env)).to eql("foo")
        end
      end

      context "with the first strategy returning nil" do
        subject { described_class.new(strategies: [MockStrategy.new(nil), MockStrategy.new('v1')]) }

        it "calls the routset" do
          subject.add_version(version: 'v1') { "foo" }
          expect(subject.call(env)).to eql("foo")
        end
      end

      context "with all strategies returning nil" do
        subject { described_class.new(strategies: [MockStrategy.new(nil), MockStrategy.new(nil)]) }
        it "calls the default" do
          subject.add_version(version: 'v1') { "foo" }
          expect(subject.call(env)[0]).to eql(404)
        end
      end
    end

    context "with two strategies using two versions" do
      subject { described_class.new(strategies: [MockStrategy.new('v1'), MockStrategy.new('v2')]) }
      context "with a routeset that uses the first strategy" do
        it "calls the routeset" do
          subject.add_version(version: 'v1') { "foo" }
          subject.add_version(version: 'v2') { "bar" }
          expect(subject.call(env)).to eql("foo")
        end
      end
    end
  end
end
