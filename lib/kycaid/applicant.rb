module KYCAID
  class Applicant < Response
    extend Client

    def self.create(params)
      protected_params = params.slice(:type, :first_name, :last_name, :dob, :residence_country, :email, :phone)
      respond(post("/applicants", protected_params))
    end

    def self.fetch(applicant_id)
      respond(get("/applicants/#{applicant_id}"))
    end
  end
end
