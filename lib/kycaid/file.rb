module KYCAID
  # File is wrapper for KYCAID Files endpoints.
  class File < Response
    extend Client

    # Creates new file.
    # * +:tempfile+ - file to upload.
    # * +:content_type+ - multipart data content type.
    # * +:original_filename+ - filename.
    #
    # Returns Response object, conatining +file_id+.
    def self.create(params)
      respond(file_post("/files", params.slice(:tempfile, :content_type, :original_filename)))
    end

    # Updates a file.
    # * +:file_id+ - file ID to update.
    # * +:tempfile+ - file to upload.
    # * +:content_type+ - multipart data content type.
    # * +:original_filename+ - filename.
    #
    # Returns Response object, conatining +file_id+.
    def self.update(params)
      respond(file_put("/files/#{params[:file_id]}",
              params.slice(:tempfile, :content_type, :original_filename)))
    end
  end
end
