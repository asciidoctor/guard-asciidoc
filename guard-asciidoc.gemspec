# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "guard/asciidoc/version"

Gem::Specification.new do |s|
  s.name        = "guard-asciidoc"
  s.version     = Guard::AsciiDocModule::VERSION
  s.authors     = ["Paul Rayner"]
  s.email       = ["paul@virtual-genius.com"]
  s.homepage    = "https://github.com/paulrayner/guard-asciidoc"
  s.summary     = %q{Guard::AsciiDoc automatically renders your AsciiDoc documents}
  s.description = %q{Watches a source folder and automatically renders AsciiDoc documents to HTML in a target folder}
  s.licenses    = ['MIT']

  s.rubyforge_project = "guard-asciidoc"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'guard', '>= 0.2.2'
  s.add_dependency 'asciidoctor', '~> 0.1.1'

  s.add_development_dependency 'rake', '~> 13.0.0'
end
