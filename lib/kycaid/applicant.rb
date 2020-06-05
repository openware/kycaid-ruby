module KYCAID
  # Applicant is wrapper for KYCAID Applicants endpoints.
  class Applicant < Response
    extend Client

    # Creates new applicant, params is a Hash.
    # * +:type+ - _required_ The applicant type. Valid values are PERSON or COMPANY.
    # * +:first_name+ - _required_ The applicant’s first name.
    # * +:last_name+ - _required_ The applicant’s last name.
    # * +:dob+ - _required_ The applicant’s day of birth date. (ISO 8601, YYYY-MM-DD).
    # * +:residence_country+ - _required_ The applicant’s current nationality. Example: GB (ISO 3166-2).
    # * +:email+ - _required_ The applicant’s email address.
    # * +:phone+ - _required_ The phone number of applicant.
    #
    # Returns Response object, conatining +applicant_id+.
    def self.create(params)
      protected_params = params.slice(:type, :first_name, :last_name, :dob, :residence_country, :email, :phone)
      respond(post("/applicants", protected_params))
    end

    # Send get request to retrieve applicant by his ID.
    #
    # Returns Response object, conatining:
    # * +:applicant_id+
    # * +:first_name+
    # * +:last_name+
    # * +:dob+
    # * +:residence_country+
    # * +:email+
    def self.fetch(applicant_id)
      respond(get("/applicants/#{applicant_id}"))
    end
  end
end
