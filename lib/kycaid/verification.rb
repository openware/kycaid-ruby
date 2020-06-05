module KYCAID
  class Verification < Response
    extend Client

    def self.create(params)
      protected_params = params.slice(:applicant_id, :types, :callback_url)
      respond(post("/verifications", protected_params))
    end

    def self.fetch(verification_id)
      respond(get("/verifications/#{verification_id}"))
    end
  end
end
