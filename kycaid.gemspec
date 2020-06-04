require_relative 'lib/kycaid/version'

Gem::Specification.new do |spec|
  spec.name          = "kycaid"
  spec.version       = KYCAID::VERSION
  spec.authors       = ["Openware"]
  spec.email         = ["hello@openware.com"]

  spec.summary       = %q{Openware ruby library to interact with KYCAID.}
  spec.description   = %q{Support of core functionality of KYC provider}
  spec.homepage      = "https://www.openware.com/"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "http://mygemserver.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/openware/kycaid"
  spec.metadata["changelog_uri"] = "https://github.com/openware/kycaid/blob/master/CHANGELOG.md"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "simplecov"

  spec.add_dependency "faraday"
  spec.add_dependency "json"
end
