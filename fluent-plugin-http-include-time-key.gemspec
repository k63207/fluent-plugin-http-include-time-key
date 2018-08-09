lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name    = "fluent-plugin-http-include-time-key"
  spec.version = "0.1.0"
  spec.authors = ["k63207"]
  spec.email   = ["k63207@gmail.com"]

  spec.summary       = %q{in_http plugin for including time tag in record in case of post multiple records.}
  spec.description   = %q{override the standard in_http plugin.}
  spec.homepage      = "https://github.com/k63207/fluent-plugin-http-include-time-key"
  spec.license       = "Apache-2.0"

  test_files, files  = `git ls-files -z`.split("\x0").partition do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.files         = files
  spec.executables   = files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = test_files
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "test-unit", "~> 3.0"
  spec.add_runtime_dependency "fluentd", [">= 0.14.10", "< 2"]
end
