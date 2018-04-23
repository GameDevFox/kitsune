# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kitsune/version'

Gem::Specification.new do |spec|
  spec.name          = 'kitsune'
  spec.version       = Kitsune::VERSION
  spec.authors       = ['Edward Nicholes Jr.']
  spec.email         = ['GameDevFox@gmail.com']

  spec.summary       = %q{Kitsune System}
  spec.description   = %q{A system creation system}
  spec.homepage      = 'https://github.com/GameDevFox/kitsune'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rack', '~> 2.0.3'
  spec.add_runtime_dependency 'rack-cors', '~> 1.0.2'
  spec.add_runtime_dependency 'sqlite3', '~> 1.3.13'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'pry', '~> 0.11.2'
  spec.add_development_dependency 'pry-doc', '~> 0.11.1'
  spec.add_development_dependency 'pry-byebug', '~> 3.5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov', '~> 0.16.1'
end
