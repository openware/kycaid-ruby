RSpec.describe KYCAID::Client do
  subject { Class.new { include KYCAID::Client }.new }

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

  before(:each) do
    KYCAID.configure do |c|
      c.authorization_token = '1MAR3SP3CTABL3t0k3N'
      c.sandbox_mode = true
      c.api_endpoint = 'http://www.wast3land.org'
    end
  end

  it 'post request with authorization header' do
    WebMock.stub_request(:post, "http://www.wast3land.org/somepath").
      with(
        body: {"param"=>"some goodness", "sandbox"=>"true"},
        headers: {
          'Authorization'=>'Token 1MAR3SP3CTABL3t0k3N',
        }).
      to_return(status: 200, body: "", headers: {})

    subject.post('/somepath', { param: 'some goodness' })
  end

  it 'get request with authorization header' do
    WebMock.stub_request(:get, "http://www.wast3land.org/somepath?param=some%20goodness&sandbox=true").
      with(
        headers: {
          'Authorization'=>'Token 1MAR3SP3CTABL3t0k3N',
        }).
      to_return(status: 200, body: "", headers: {})

    subject.get('/somepath', { param: 'some goodness' })
  end

  it 'patch request with authorization header' do
    WebMock.stub_request(:patch, "http://www.wast3land.org/somepath").
      with(
        body: {"param"=>"some goodness", "sandbox"=>"true"},
        headers: {
          'Authorization'=>'Token 1MAR3SP3CTABL3t0k3N',
        }).
      to_return(status: 200, body: "", headers: {})

    subject.patch('/somepath', { param: 'some goodness' })
  end

  it 'file_post request with authorization header' do
    WebMock.stub_request(:post, "http://www.wast3land.org/somepath").
      with(
        headers: {
          'Authorization'=>'Token 1MAR3SP3CTABL3t0k3N',
        }).
      to_return(status: 200, body: "", headers: {})

    subject.file_post('/somepath', document_params)
  end

  it 'file_post request with authorization header' do
    WebMock.stub_request(:put, "http://www.wast3land.org/somepath").
      with(
        headers: {
          'Authorization'=>'Token 1MAR3SP3CTABL3t0k3N',
        }).
      to_return(status: 200, body: "", headers: {})

    subject.file_put('/somepath', document_params)
  end
end
