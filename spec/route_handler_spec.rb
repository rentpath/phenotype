RSpec.describe Phenotype::RouteHandler do
  describe '#cascade?' do
    context 'When true' do
      let(:not_found) { [404, { 'X-Cascade' => 'pass' }, ['not found']] }
      subject { described_class.new(cascade: true, block: ->(_) { not_found }).cascade? }

      it { is_expected.to be_truthy }
    end
    context 'When false and 404' do
      let(:not_found) { [404, {}, ['not found']] }
      subject { described_class.new(cascade: false, block: ->(_) { not_found }).cascade? }

      it { is_expected.to be_falsy }
    end
    context 'When false and 200' do
      let(:not_found) { [200, {}, ['success']] }
      subject { described_class.new(cascade: false, block: ->(_) { not_found }).cascade? }

      it { is_expected.to be_falsy }
    end
  end
end
