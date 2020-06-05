module KYCAID
  # Response is an object to wrap parsed json response.
  class Response < OpenStruct
    def initialize(response)
      super(response)
    end

    # * If response is not successful, set errors to array of detected errors.
    # * If response is successful, errors in nil.
    # * If raise_errors is set in configuration, will raise error if any.
    def handle_error(err)
      self.errors ||= []
      self.errors << err

      raise err if KYCAID.configuration.raise_errors

      self
    end

    # Wraps JSON response into OpenStruct.
    # Original response in stored in +raw_response+
    def self.respond(response)
      resp = new(JSON.parse(response.body))
      resp.raw_response = response

      resp.handle_error(Unauthorized.new(response.body)) if response.status == 403
      resp.handle_error(Error.new(response.body)) unless response.success?

      resp
    end
  end
end
