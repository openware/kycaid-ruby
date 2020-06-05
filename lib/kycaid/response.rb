module KYCAID
  class Response < OpenStruct
    def initialize(response)
      super(response)
    end

    def handle_error(err)
      self.errors ||= []
      self.errors << err

      raise err if KYCAID.configuration.raise_errors

      self
    end

    def self.respond(response)
      resp = new(JSON.parse(response.body))
      resp.raw_response = response

      resp.handle_error(Unauthorized.new(response.body)) if response.status == 403
      resp.handle_error(Error.new(response.body)) unless response.success?

      resp
    end
  end
end
