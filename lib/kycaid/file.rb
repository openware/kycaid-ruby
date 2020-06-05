module KYCAID
  class File < Response
    extend Client

    def self.create(params)
      respond(file_post("/files", params.slice(:tempfile, :content_type, :original_filename)))
    end

    def self.update(params)
      respond(file_put("/files/#{params[:file_id]}",
              params.slice(:tempfile, :content_type, :original_filename)
                    .merge(sandbox: sandbox?)))
    end
  end
end
