module KYCAID
  class File < OpenStruct
    extend Client

    def self.create(params)
      response = file_post("/files", params.slice(:tempfile, :content_type, :original_filename))
      new(JSON.parse(response.body))
    end

    def self.update(params)
      response = file_put("/files/#{params[:file_id]}", params.slice(:tempfile, :content_type, :original_filename).merge(sandbox: KYCAID.configuration.sandbox_mode))
      new(JSON.parse(response.body))
    end

    def initialize(response)
      super(response)
      self.raw_response = response
    end
  end
end
