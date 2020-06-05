module KYCAID
  class Configuration
    attr_accessor :authorization_token
    attr_accessor :sandbox_mode
    attr_accessor :api_endpoint
    attr_accessor :raise_errors

    def initialize
      @authorization_token = "d9883415047de3439328df17b0310569669a"
      @sandbox_mode = true
      @api_endpoint = "https://api.kycaid.com/"
      @raise_errors = false
    end
  end
end
