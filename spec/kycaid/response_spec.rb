RSpec.describe KYCAID::Response do
  subject do
    Class.new(KYCAID::Response) do
      extend KYCAID::Client

      def self.test
        respond(post("/hello"))
      end
    end
  end

  before(:all) { VCR.turn_off! }
  after(:all) { VCR.turn_on! }

  let(:fake_response) { '{"dwarf": "J0hny"}' }

  context 'with raising disabled' do
    before(:all) do
      KYCAID.configure do |c|
        c.authorization_token = '1MAR3SP3CTABL3t0k3N'
        c.sandbox_mode = true
        c.api_endpoint = 'http://www.wast3land.org'
        c.raise_errors = false
      end
    end

    it 'successful response' do
      WebMock.stub_request(:post, "http://www.wast3land.org/hello").
        to_return(status: 200, body: fake_response, headers: {})
  
      resp = subject.test
      expect(resp.errors).to be_nil
      expect(resp.dwarf).to eq "J0hny"
    end

    it 'if status is 403 contains Unauthorized error' do
      WebMock.stub_request(:post, "http://www.wast3land.org/hello").
        to_return(status: 403, body: fake_response, headers: {})
  
      resp = subject.test
      expect(resp.errors).not_to be_nil
      expect(resp.errors[0]).to be_a KYCAID::Unauthorized
      expect(resp.dwarf).to eq "J0hny"
    end

    it 'if status is 422 contains Error' do
      WebMock.stub_request(:post, "http://www.wast3land.org/hello").
        to_return(status: 422, body: fake_response, headers: {})
  
      resp = subject.test
      expect(resp.errors).not_to be_nil
      expect(resp.errors[0]).to be_a KYCAID::Error
      expect(resp.dwarf).to eq "J0hny"
    end
  end

  context 'with raising enabled' do
    before(:all) do
      KYCAID.configure do |c|
        c.authorization_token = '1MAR3SP3CTABL3t0k3N'
        c.sandbox_mode = true
        c.api_endpoint = 'http://www.wast3land.org'
        c.raise_errors = true
      end
    end

    after(:all) { KYCAID.configure { |c| c.raise_errors = false } }

    it 'successful response' do
      WebMock.stub_request(:post, "http://www.wast3land.org/hello").
        to_return(status: 200, body: fake_response, headers: {})
  
      resp = subject.test
      expect(resp.errors).to be_nil
      expect(resp.dwarf).to eq "J0hny"
    end

    it 'if status is 403 contains Unauthorized error' do
      WebMock.stub_request(:post, "http://www.wast3land.org/hello").
        to_return(status: 403, body: fake_response, headers: {})
  
      expect { subject.test }.to raise_error KYCAID::Unauthorized
    end

    it 'if status is 422 contains Error' do
      WebMock.stub_request(:post, "http://www.wast3land.org/hello").
        to_return(status: 422, body: fake_response, headers: {})
  
      expect { subject.test }.to raise_error KYCAID::Error
    end
  end
end
