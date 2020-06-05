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

module KYCAID
  class Error < StandardError; end
  class Unauthorized < Error; end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end
end
