module KYCAID
  class Document < OpenStruct
    extend Client

    def self.create(params)
      front_file_id = file_params(params[:front_file]) unless params[:front_file].compact.empty?
      back_file_id = file_params(params[:back_file]) unless params[:back_file].compact.empty?

      protected_params = params.slice(:applicant_id, :type, :document_number, :issue_date, :expiry_date)
                               .merge(front_side_id: front_file_id, back_side_id: back_file_id)

      response = post("/documents", protected_params.compact)
      new(JSON.parse(response.body))
    end

    def self.patch(applicant_id)
      protected_params = params.slice(:document_id, :applicant_id, :type, :document_number, :issue_date, :expiry_date, :front_side_id, :back_side_id)
      response = get("/documents/#{document_id}", protected_params)
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
