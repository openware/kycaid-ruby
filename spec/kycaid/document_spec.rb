RSpec.describe KYCAID::Document do
  subject { KYCAID::Document }

  before(:all) { VCR.turn_off! }
  after(:all) { VCR.turn_on! }

  let(:temp_file) { open('spec/fixtures/passport.jpg') }
  let(:content_type) { "jpg" }
  let(:original_filename) {"foo.jpg"}
  let(:document_params) do
    {
      tempfile: temp_file,
      file_extension: content_type,
      file_name: original_filename
    }
  end
  let(:params) do
    {
      id: 67,
      front_file: document_params,
      back_file: document_params,
      applicant_id: 'someID',
      type: 'docType',
      document_number: 'numb',
      issue_date: 'date',
      expiry_date: 'date too',    
    }
  end

  context 'create' do
    it 'posts two files and a document' do
      allow(KYCAID::File).to receive(:file_post).with('/files', {
        tempfile: temp_file,
        content_type: "image/jpg",
        original_filename: original_filename
      }) { OpenStruct.new(body: '{"file_id": 3}') }

      allow(subject).to receive(:post).with('/documents', {
        applicant_id: "someID",
        back_side_id: 3,
        document_number: "numb",
        expiry_date: "date too",
        front_side_id: 3,
        issue_date: "date",
        type: "docType",
      })  { OpenStruct.new(body: '{}') }
      
      subject.create(params)
    end
  end

  context 'update' do
    it 'patches a document by id' do
      allow(subject).to receive(:patch).with('/documents/67', {
        document_number: "numb",
        expiry_date: "date too",
        issue_date: "date",
        type: "docType",
      })  { OpenStruct.new(body: '{}') }
      
      subject.update(params)
    end
  end
end