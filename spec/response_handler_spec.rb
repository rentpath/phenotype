RSpec.describe Phenotype::ResponseHandler do
  let(:response) { [200, { 'Content-Type' => 'text/html' }, ['sucess']] }
  let(:handler) { described_class.new(response) }

  describe '#valid_response?' do
    subject { handler.send(:valid_response?) }
    context 'When type is an Array' do
      it 'be true' do
        expect(subject).to be_truthy
      end
    end

    context 'When type is not an Array' do
      let(:response) { 'Failed call' }
      subject { handler.send(:valid_response?) }

      it 'be false' do
        expect(subject).to be_falsey
      end
    end
  end

  describe '#retry?' do
    context '404 and X-Cascade' do
      let(:response) { [404, { 'X-Cascade' => 'pass' }, ['sucess']] }
      subject { handler.retry? }

      it { is_expected.to be_truthy }
    end

    context '404' do
      let(:response) { [200, { }, ['sucess']] }
      subject { handler.retry? }

      it { is_expected.to be_falsey }
    end

    context '200 and X-CascadeCascade' do
      let(:response) { [200, { 'X-Cascade' => 'pass' }, ['sucess']] }
      subject { handler.retry? }

      it { is_expected.to be_falsey }
    end
  end
end
