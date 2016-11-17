require 'ostruct'

RSpec.describe Phenotype::Versioner do
  class MockStrategy
    def initialize(version)
      @version = version
    end

    def version(env)
      @version
    end
  end

  let(:routes) { {} }
  let(:strategies) { [] }
  let(:env) { {} }

  let(:versioner) do
    described_class.new(
      routes: routes,
      strategies: strategies,
      env: env
    )
  end

  describe '#errors?' do
    subject { versioner.send(:errors?) }
    it 'be true' do
      expect(subject).to be_truthy
    end

    context 'When no Errors' do
      let(:strategies) { [Phenotype::HeaderStrategy.new(header: 'API_VERSION')] }
      let(:routes) { { 1 => '1', 2 => '2' } }
      let(:env) { { 'HTTP_API_VERSION' => '2' } }
      subject { versioner.send(:errors?) }

      it 'be false' do
        expect(subject).to be_falsey
      end
    end
  end

  describe '#maybe_display_errors' do
    context 'No Strategies' do
      subject { versioner.send(:display_errors) }
      it 'return 406' do
        expect(subject).to eql([406, {'Content-Type' => 'text/html'}, ['No Strategies provided']])
      end

      it 'has errors' do
        expect(versioner.send(:errors?)).to be_truthy
      end
    end

    context 'Too Many Strategies' do
      let(:strategies) { [MockStrategy.new(1), MockStrategy.new(2)] }
      subject { versioner.send(:display_errors) }

      it 'return 400' do
        expect(subject).to(
          eql([400, {'Content-Type' => 'text/html'}, ['Too mant strategies provided, Supports only one']])
        )
      end

      it 'has errors' do
        expect(versioner.send(:errors?)).to be_truthy
      end
    end

    context 'Too Many Strategies' do
      let(:strategies) { [Phenotype::HeaderStrategy.new(header: 'API_VERSION')] }
      let(:routes) { { 1 => '1', 2 => '2' } }
      let(:env) { { 'HTTP_API_VERSION' => '3' } }

      subject { versioner.send(:display_errors) }

      it 'return 406' do
        expect(subject).to(
          eql([406,
               { 'Content-Type' => 'text/html' },
               ["Version: #{versioner.send(:current_version)} is not found"]])
        )
      end

      it 'has errors' do
        expect(versioner.send(:errors?)).to be_truthy
      end
    end
  end

  describe '#cascading_versions' do
    let(:strategies) { [Phenotype::HeaderStrategy.new(header: 'API_VERSION')] }
    let(:routes) { { 1 => '1', 2 => '2', 3 => '3' } }
    subject { versioner.send(:cascading_versions) }

    context 'With all versions' do
      let(:env) { { 'HTTP_API_VERSION' => '3' } }
      it 'returns Array of supported versions' do
        expect(subject).to eql([3, 2, 1])
      end
    end

    context 'With subset versions' do
      let(:env) { { 'HTTP_API_VERSION' => '2' } }
      it 'returns Array of supported versions' do
        expect(subject).to eql([2, 1])
      end
    end
  end

  describe '#call' do
    subject { versioner.call }

    context 'When Errors exist' do
      subject { versioner.call.first }
      it { is_expected.to eql 406 }
    end

    context 'When No Errors' do
      let(:ok_response) { [200, { 'Content-Type' => 'text/html' }, ['sucess']] }
      let(:strategies) { [Phenotype::HeaderStrategy.new(header: 'API_VERSION')] }
      let(:not_found) { [404, { 'X-Cascade' => 'pass' }, ['not found']] }
      let(:env) { { 'HTTP_API_VERSION' => '3' } }
      let(:routes) do
        {
          2 => Phenotype::RouteHandler.new(cascade: false, block: ->(_) { not_found }),
          3 => Phenotype::RouteHandler.new(cascade: true, block: ->(_) { ok_response })
        }
      end

      context 'and version matches existing route call' do
        it { is_expected.to eql ok_response }
      end

      context 'and version will use cascading calls' do
        context 'with 200 response' do
          let(:routes) do
            {
              1 => Phenotype::RouteHandler.new(cascade: false, block: ->(_) { ok_response }),
              2 => Phenotype::RouteHandler.new(cascade: false, block: ->(_) { ok_response }),
              3 => Phenotype::RouteHandler.new(cascade: true, block: ->(_) { not_found })
            }
          end

          it { is_expected.to eql ok_response }
        end

        context 'with 500 response' do
          let(:error_response) { [500, {}, ['error']] }
          let(:routes) do
            {
              1 => Phenotype::RouteHandler.new(cascade: false, block: ->(_) { error_response }),
              2 => Phenotype::RouteHandler.new(cascade: true, block: ->(_) { not_found }),
              3 => Phenotype::RouteHandler.new(cascade: true, block: ->(_) { not_found })
            }
          end

          it { is_expected.to eql error_response }
        end

        context 'And do not cascade' do
          let(:routes) do
            {
              1 => Phenotype::RouteHandler.new(cascade: false, block: ->(_) { error_response }),
              2 => Phenotype::RouteHandler.new(cascade: true, block: ->(_) { ok_response }),
              3 => Phenotype::RouteHandler.new(cascade: false, block: ->(_) { not_found })
            }
          end

          it { is_expected.to eql not_found }
        end
      end
    end
  end
end
