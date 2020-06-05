module KYCAID
  class Address < Response
    extend Client

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
