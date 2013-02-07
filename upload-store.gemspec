# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'upload_store/version'

Gem::Specification.new do |gem|
  gem.name          = "upload-store"
  gem.version       = UploadStore::VERSION
  gem.authors       = ["Jeshua Borges"]
  gem.email         = ["jesh@jesh.me"]

  gem.description   = %q{Rails is terrible at streaming uploaded files. So, move that upload handling to
    what ever file store your already using and rely on ruby to handle the processing.}
  gem.summary       = %q{Allow clients to upload directly to cloud based file services.}
  gem.homepage      = "http://github.com/jeshuaborges/upload-store"

  gem.add_dependency 'activesupport', '>= 3.2'
  gem.add_dependency 'fog', '>=1.8.0'

  gem.add_development_dependency 'rspec'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
