module KYCAID
  # Document is wrapper for KYCAID Documents endpoints.
  class Document < Response
    extend Client

    # Creates +:front_file+ and +:back_file+ files (see File) and a document,referring to those files.
    # * +:applicant_id+ - _required_ The applicant’s unique identificator that received in response of Applicant#create.
    # * +:type+ - _required_ The document type. Valid values are: GOVERNMENT_ID, PASSPORT, DRIVERS_LICENSE, SELFIE_IMAGE,
    # ADDRESS_DOCUMENT, FINANCIAL_DOCUMENT, TAX_ID_NUMBER, REGISTRATION_COMPANY, COMPANY_LEGAL_ADDRESS, AUTHORISED_PERSON,
    # COMPANY_OWNERSHIP.
    # * +:document_number+ - The unique number associated with document (e.g. passport number).
    # * +:issue_date+ - The issue date of the document. (ISO 8601, YYYY-MM-DD).
    # * +:expiry_date+ - The expiry date of the document. (ISO 8601, YYYY-MM-DD)
    # * +:front_file+ - nested param to create a file.
    # * +:back_file+ - nested param to create a file.
    #
    # Front file and Back file are a Hash:
    # * +:tempfile+ - file to upload.
    # * +:file_extension+ - file's extensions (f.e., .jpeg)
    # * +:file_name+ - filename.
    #
    # Returns Response object, conatining +document_id+.
    def self.create(params)
      front_file_id = create_file(params[:front_file])
      back_file_id = create_file(params[:back_file])

      protected_params = params.slice(:applicant_id, :type, :document_number, :issue_date, :expiry_date)
                               .merge(front_side_id: front_file_id, back_side_id: back_file_id)

      respond(post("/documents", protected_params.compact))
    end

    # Update document, params is a Hash.
    # * +:type+ - see #create
    # * +:document_number+ - see #create
    # * +:issue_date+ - see #create
    # * +:expiry_date+ - see #create
    # Front file and Back file are a Hash:
    # * +:tempfile+ - file to upload.
    # * +:file_extension+ - file's extensions (f.e., .jpeg)
    # * +:file_name+ - filename.
    #
    # Returns Response object, conatining +document_id+.
    def self.update(params)
      front_file_id = create_file(params[:front_file])
      back_file_id = create_file(params[:back_file])

      protected_params = params.slice(:type, :document_number, :issue_date, :expiry_date)
                               .merge(front_side_id: front_file_id, back_side_id: back_file_id)
      respond(patch("/documents/#{params[:id]}", protected_params))
    end

    # A helper to create associated file before creating document.
    # Return a File Response object.
    def self.file_params(params)
      KYCAID::File.create(
        tempfile: params[:tempfile],
        content_type: "image/#{params[:file_extension]}",
        original_filename: params[:file_name]
      )
    end

    def self.create_file(file)
      unless file.nil?
        front_file = file_params(file)
        return front_file unless front_file.errors.nil?

        front_file.file_id
      end
    end
  end
end
