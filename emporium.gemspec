# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "emporium/version"

Gem::Specification.new do |s|
  s.name        = "emporium"
  s.version     = Emporium::VERSION
  s.authors     = ["Hugo Bastien"]
  s.email       = ["hugobast@gmail.com"]
  s.homepage    = "https://github.com/hugobast/emporium"
  s.summary     = %q{Emporium fetches information about a product from it's UPC (GTIN-12)}
  s.description = %q{Uses Amazon's product advertising API or Google's Shopping Search API}

  s.rubyforge_project = "emporium"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'nokogiri'
  s.add_dependency 'ruby-hmac'
  s.add_dependency 'json'

  s.add_development_dependency "rspec"
end
