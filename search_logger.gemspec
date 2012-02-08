# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "search_logger/version"

Gem::Specification.new do |s|
  s.name        = "search_logger"
  s.version     = SearchLogger::VERSION
  s.authors     = ["kurko"]
  s.email       = ["chavedomundo@gmail.com"]
  s.homepage    = "http://github.com/kurko/search_logger"
  s.summary     = %q{Searches Google and saves results.}
  s.description = %q{This gem reads keywords from a given XML file, searching them on Google. All results are then stored into MySQL and later exported to CSV. This is a concept app. See the gem's website for documentation.}

  s.rubyforge_project = "search_logger"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "guard"
  s.add_runtime_dependency "nokogiri"
  s.add_runtime_dependency "httpclient"
  s.add_runtime_dependency "mysql2"
end
