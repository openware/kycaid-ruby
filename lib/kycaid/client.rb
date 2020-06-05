module KYCAID
  # Client contins REST API and handles content type and injecting Authorization token.
  module Client
    # Returns Faraday connection with authorization header containing token.
    def conn
      @conn ||= Faraday.new(url: KYCAID.configuration.api_endpoint).tap do |faraday|
        faraday.authorization("Token", KYCAID.configuration.authorization_token)
      end
    end

    # Returns Faraday connection for multipart data uploading with authorization header containing token.
    def multipart_conn
      @multipart_conn ||= Faraday.new(url: KYCAID.configuration.api_endpoint) do |faraday|
        faraday.request :multipart
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
        faraday.authorization("Token", KYCAID.configuration.authorization_token)
      end
    end

    # Returns true if sandbox mode is set.
    def sandbox?
      KYCAID.configuration.sandbox_mode
    end

    # Performs a get request, adds sandbox flag to request.
    def get(url, options={})
      conn.get(url, options.merge(sandbox: sandbox?))
    end

    # Performs a post request, adds sandbox flag to request.
    def post(url, params={})
      conn.post(url, params.merge(sandbox: sandbox?))
    end

    # Performs a patch request, adds sandbox flag to request.
    def patch(url, params={})
      conn.patch(url, params.merge(sandbox: sandbox?))
    end

    # Performs a post request with multipart data, adds sandbox flag to request.
    def file_post(url, params={})
      multipart_conn.post(url, file_payload(params))
    end

    # Performs a put request with multipart data, adds sandbox flag to request.
    def file_put(url, params={})
      multipart_conn.put(url, file_payload(params))
    end

    # Returns multipart data body params.
    def file_payload(params={})
      file = Faraday::UploadIO.new(
        params[:tempfile].path,
        params[:content_type],
        params[:original_filename]
      )
      payload = { :file => file }.merge(sandbox: sandbox?)
      payload
    end
  end
end
