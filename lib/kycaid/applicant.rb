module KYCAID
  class Applicant < OpenStruct
    extend Client

    def self.create(params)
      protected_params = params.slice(:type, :first_name, :last_name, :dob, :residence_country, :email, :phone)
      response = post("/applicants", protected_params)
      new(JSON.parse(response.body))
    end

    def self.fetch(applicant_id)
      response = get("/applicants/#{applicant_id}")
      new(JSON.parse(response.body))
    end

    def initialize(response)
      super(response)
      self.raw_response = response
    end
  end
end
