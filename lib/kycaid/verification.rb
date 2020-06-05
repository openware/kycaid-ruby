module KYCAID
  # Verification is wrapper for KYCAID Verifications endpoints.
  class Verification < Response
    extend Client

    # Create a verification.
    # * +:applicant_id+ - _required_ The applicant unique identificator that received in response of Applicant#create.
    # * +:types+ - _required_ The verification types. Valid values are: DOCUMENT, FACIAL, ADDRESS, AML, FINANCIAL, VIDEO, COMPANY.
    # * +:callback_url+ - _required_ URL on which the result will come.
    #
    # See https://docs.kycaid.com/#create-a-verification for more info.
    # 
    # Returns Response object, conatining +verification_id+.
    def self.create(params)
      protected_params = params.slice(:applicant_id, :types, :callback_url)
      respond(post("/verifications", protected_params))
    end

    # Retrieve a verification by it's id.
    #
    # Returns Response object, conatining:
    # * +:verification_id+ - The verification’s unique identificator.
    # * +:status+ - Status of verification. Possible values: +unused+, +pending+, +completed+.
    # * +:verified+ - Result of verification. Possible values: +true+ or +false+.
    # * +:verifications+ - VerificationsList object.
    # 
    # See https://docs.kycaid.com/#retrieve-a-verification for more info.
    def self.fetch(verification_id)
      respond(get("/verifications/#{verification_id}"))
    end
  end
end
