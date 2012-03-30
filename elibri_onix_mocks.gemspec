# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "elibri_onix_mocks/version"

Gem::Specification.new do |s|
  s.name        = "elibri_onix_mocks"
  s.version     = ElibriOnixMocks::VERSION
  s.authors     = ["Piotr Szmielew"]
  s.email       = ["p.szmielew@ava.waw.pl"]
  s.homepage    = ""
  s.summary     = %q{Gem that allows you to mock eLibri style xmls}
  s.description = %q{Usage: Elibri::XmlGenerator.basic_product etc}

  s.rubyforge_project = "elibri_onix_mocks"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency 'ruby-debug'

  # s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "elibri_onix_dict"
  s.add_runtime_dependency 'elibri_api_client'
  s.add_runtime_dependency "mocha"
  s.add_runtime_dependency "builder"
  s.add_runtime_dependency "activesupport"
end
