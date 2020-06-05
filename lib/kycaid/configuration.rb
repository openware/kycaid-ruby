module KYCAID
  # Configuration contains KYCAID gem preferences.
  # * +:authorization_token+ - KYCAID acces token.
  # * +:sandbox_mode+ - run requests in sandbox mode.
  # * +:api_endpoint+ - KYCAID service endpoint.
  # * +:raise_errors+ - if set to true, KYCAID errors (like unauthorized) will be raised, otherwise access errors by Response#errors.
  class Configuration
    attr_accessor :authorization_token
    attr_accessor :sandbox_mode
    attr_accessor :api_endpoint
    attr_accessor :raise_errors

    # Initizes configuration with default values.
    def initialize
      @authorization_token = "d9883415047de3439328df17b0310569669a"
      @sandbox_mode = true
      @api_endpoint = "https://api.kycaid.com/"
      @raise_errors = false
    end
  end
end
