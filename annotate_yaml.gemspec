# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'annotate_yaml/version'

Gem::Specification.new do |spec|
  spec.name          = "annotate_yaml"
  spec.version       = AnnotateYaml::VERSION
  spec.authors       = ["Pierre URBAN"]
  spec.email         = ["urban.pierre@gmail.com"]
  spec.summary       = %q{Annote YAML to annotate your YAML files.}
  spec.description   = %q{Annote YAML to annotate your YAML files}
  spec.homepage      = "https://github.com/purban/annotate_yaml"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
