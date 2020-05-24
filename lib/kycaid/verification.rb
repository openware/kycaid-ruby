module KYCAID
  class Verification < OpenStruct
    extend Client

    def self.create(params)
      protected_params = params.slice(:applicant_id, :types, :callback_url)
      response = post("/verifications", protected_params)
      new(JSON.parse(response.body))
    end

    def self.fetch(verification_id)
      response = get("/verifications/#{verification_id}")
      new(JSON.parse(response.body))
    end

    def initialize(response)
      super(response)
      self.raw_response = response
    end
  end
end
