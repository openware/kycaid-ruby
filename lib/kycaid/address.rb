module KYCAID
  # Address is wrapper for KYCAID Address endpoints.
  class Address < Response
    extend Client

    # Creates new address, params is a Hash.
    # * +:applicant_id+ - _required_ The applicant’s unique identificator that received in response of create an applicant.
    # * +:type+ -         _required_ The address type. Valid values are: +'REGISTERED', 'BUSINESS', 'ADDITIONAL'+.
    # * +:country+ -      The country of the applicants’s address. Example: GB (ISO 3166-2).
    # * +:city+ -         The city or town of the applicant’s address.
    # * +:postal_code+ -  The post or zip code of the applicant’s address.
    # * +:full_address+ - The applicant’s full address.
    #
    # Returns Response object, conatining +address_id+.
    def self.create(params)
      response = KYCAID::Document.create(
        {
          front_file: params[:front_file],
          applicant_id: params[:applicant_id],
          type: 'ADDRESS_DOCUMENT'
        }
      )
      return response unless response.errors.nil?

      protected_params = params.slice(:country, :city, :postal_code, :full_address, :applicant_id, :type)

      respond(post("/addresses", protected_params))
    end
  end
end
