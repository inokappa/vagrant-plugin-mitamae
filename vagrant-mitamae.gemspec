lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-mitamae/version'

Gem::Specification.new do |spec|
  spec.name          = 'vagrant-mitamae'
  spec.version       = VagrantPlugins::Mitamae::VERSION
  spec.authors       = ['inokappa']
  spec.email         = ['inokara@gmail.com']

  spec.summary       = %q{A Vagrant plugin that executes mitamae}
  spec.description   = 'vagrant-plugin-mitamae is a Vagrant plugin that integrates serverspec into your workflow.'
  spec.homepage      = 'https://github.com/inokappa/vagrant-plugin-mitamae'
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")
  spec.files          = `git ls-files`.split($/)
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'specinfra'

  spec.add_development_dependency 'bundler', '~> 1.17.3', '>= 1.17'
  spec.add_development_dependency 'rake', '>= 12.3.3'
end
