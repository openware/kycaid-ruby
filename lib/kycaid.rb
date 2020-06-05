require "faraday"
require "json"
require "ostruct"

require "kycaid/version"
require "kycaid/configuration"
require "kycaid/client"
require "kycaid/response"
require "kycaid/applicant"
require "kycaid/file"
require "kycaid/document"
require "kycaid/address"
require "kycaid/verification"

# KYCAID module contains wrappers around KYCAID API.
# See https://kycaid.com/
module KYCAID
  
  # Error is generic error used in this gem.
  # All defined errors are inherited from Error.
  class Error < StandardError; end

  # Unauthorized is raised when 403 status returned,
  # when request is correct but refuses to authorize it.
  # Check your token or contact KYCAID support.
  class Unauthorized < Error; end

  class << self
    attr_accessor :configuration
  end

  # Coinfigure allows to change gem preferences. Check Configuration for the list of options.
  # ==== Example
  #
  # KYCAID.configure do |c|
  #   c.authorization_token = '1MAR3SP3CTABL3t0k3N'
  #   c.sandbox_mode = false
  #   c.api_endpoint = 'https://api.kycaid.com/'
  #   c.raise_errors = true
  # end
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end
end
