require_relative 'lib/exchange_rate_manager/version'

Gem::Specification.new do |spec|
  spec.name          = "exchange_rate_manager"
  spec.version       = ExchangeRateManager::VERSION
  spec.authors       = ["Paul Hernández"]
  spec.email         = ["mpaul.hernandez@gmail.com"]

  spec.summary       = %q{Private project for managing exchange rates for Contalink app}
  spec.description   = %q{The project is build using the bundle's provided scaffolding utility}
  spec.homepage      = "http://www.contalink.com"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.metadata["allowed_push_host"] = ""

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "http://www.contalink.com"
  spec.metadata["changelog_uri"] = "http://www.contalink.com"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
