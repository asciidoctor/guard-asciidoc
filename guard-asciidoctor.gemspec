# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "guard-asciidoctor/version"

Gem::Specification.new do |s|
  s.name        = "guard-asciidoctor"
  s.version     = Guard::Asciidoctor::VERSION
  s.authors     = ["Paul Rayner"]
  s.email       = ["paul@virtual-genius.com"]
  s.homepage    = "https://github.com/paulrayner/guard-asciidoctor"
  s.summary     = %q{Guard::Asciidoctor automatically renders your Asciidoc documents}
  s.description = %q{Watches a source folder and automatically renders AsciiDoc documents to HTML in a target folder}

  s.rubyforge_project = "guard-asciidoctor"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'guard', '>= 0.2.2'
  s.add_dependency 'asciidoctor', '~> 0.1.1'

# Add development dependencies per https://github.com/guard/guard-markdown/blob/master/guard-markdown.gemspec
end