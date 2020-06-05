module KYCAID
  class Document < Response
    extend Client

    def self.create(params)
      front_file_id = unless params[:front_file].nil?
        front_file = file_params(params[:front_file])
        return front_file unless front_file.errors.nil?

        front_file.file_id
      end

      back_file_id = unless params[:back_file].nil?
        back_file = file_params(params[:back_file])
        return back_file unless back_file.errors.nil?

        back_file.file_id
      end

      protected_params = params.slice(:applicant_id, :type, :document_number, :issue_date, :expiry_date)
                               .merge(front_side_id: front_file_id, back_side_id: back_file_id)

      respond(post("/documents", protected_params.compact))
    end

    def self.update(params)
      protected_params = params.slice(:type, :document_number, :issue_date, :expiry_date, :front_side_id, :back_side_id)
      respond(patch("/documents/#{params[:id]}", protected_params))
    end

    def self.file_params(params)
      KYCAID::File.create(
        tempfile: params[:tempfile],
        content_type: "image/#{params[:file_extension]}",
        original_filename: params[:file_name]
      )
    end
  end
end
