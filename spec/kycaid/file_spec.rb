RSpec.describe KYCAID::File do
  subject { KYCAID::File }

  let(:temp_file) { open('spec/fixtures/passport.jpg') }
  let(:content_type) { "jpg" }
  let(:original_filename) {"foo.jpg"}
  let(:document_params) do
    {
      tempfile: temp_file,
      content_type: content_type,
      original_filename: original_filename
    }
  end
  let(:empty_response) { OpenStruct.new(body: '{}') }

  context 'create' do
    it 'create POSTs params to /files with file params only' do
      params = document_params.merge(some: 'param')
      allow(subject).to receive(:file_post).with('/files', {
        tempfile: temp_file,
        content_type: content_type,
        original_filename: original_filename
      }) { empty_response }

      subject.create(params)
    end
  end

  context 'update' do
    it 'update PUTs params to /files with file params only' do
      params = document_params.merge(some: 'param', file_id: 32)
      allow(subject).to receive(:file_put).with('/files/32', {
        tempfile: temp_file,
        content_type: content_type,
        original_filename: original_filename,
      }) { empty_response }

      subject.update(params)
    end
  end
end