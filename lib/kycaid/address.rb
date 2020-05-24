module KYCAID
  class Address < OpenStruct
    extend Client

    def self.create(params)
      front_file_id = file_params(params[:front_file]) unless params[:front_file].compact.empty?

      protected_params = params.slice(:type, :country, :state_or_province, :city, :postal_code, :street_name, :building_number, :applicant_id)
                               .merge(front_side_id: front_file_id)
      response = post("/addresses", protected_params)
      new(JSON.parse(response.body))
    end

    def self.fetch(params)
      protected_params = params.slice(:address_id, :country, :state_or_province, :city, :postal_code, :street_name, :building_number)
      response = patch("/addresses/#{address_id}", protected_params)
      new(JSON.parse(response.body))
    end

    def self.file_params(params)
      KYCAID::File.create(
        tempfile: params[:tempfile],
        content_type: "image/#{params[:file_extension]}",
        original_filename: params[:file_name]
      ).file_id
    end

    def initialize(response)
      super(response)
      self.raw_response = response
    end
  end
end
