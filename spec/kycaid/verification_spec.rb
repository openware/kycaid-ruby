RSpec.describe KYCAID::Verification do
  subject { KYCAID::Verification }

  let(:empty_response) { OpenStruct.new(body: '{}') }

  context 'fetch' do
    it 'fetch GETs /verifications by id' do
      allow(subject).to receive(:get).with('/verifications/42') { empty_response }

      subject.fetch(42)
    end
  end

  context 'create' do
    it 'create POSTs params to /verifications' do
      allow(subject).to receive(:post).with('/verifications', {}) { empty_response }

      subject.create({})
    end

    it 'sends only protected params' do
      allow(subject).to receive(:post)
        .with('/verifications', {
                applicant_id: 'app_id',
                types: 'someTypes',
                callback_url: 'www.hogwartz.com'
              }) { empty_response }

      subject.create(
        applicant_id: 'app_id',
        types: 'someTypes',
        callback_url: 'www.hogwartz.com',
        unwanted: 'some param',
      )
    end
  end
end
