module KYCAID
  module Client
    def conn
      @conn ||= Faraday.new(url: KYCAID.configuration.api_endpoint).tap do |faraday|
        faraday.authorization("Token", KYCAID.configuration.authorization_token)
      end
    end

    def multipart_conn
      @multipart_conn ||= Faraday.new(url: KYCAID.configuration.api_endpoint) do |faraday|
        faraday.request :multipart
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
        faraday.authorization("Token", KYCAID.configuration.authorization_token)
      end
    end

    def sandbox?
      KYCAID.configuration.sandbox_mode
    end

    def get(url, options={})
      conn.get(url, options.merge(sandbox: sandbox?))
    end

    def post(url, params={})
      conn.post(url, params.merge(sandbox: sandbox?))
    end

    def patch(url, params={})
      conn.patch(url, params.merge(sandbox: sandbox?))
    end

    def file_post(url, params={})
      multipart_conn.post(url, file_payload(params))
    end

    def file_put(url, params={})
      multipart_conn.put(url, file_payload(params))
    end

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
