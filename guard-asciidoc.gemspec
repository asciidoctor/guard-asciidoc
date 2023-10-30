# frozen_string_literal: true

begin
  require_relative 'lib/guard/asciidoc/version'
rescue LoadError
  require 'guard/asciidoc/version'
end

Gem::Specification.new do |s|
  s.name = 'guard-asciidoc'
  s.version = Guard::AsciiDoc::VERSION
  s.summary = 'Guard::AsciiDoc automatically converts your AsciiDoc documents.'
  s.description = 'Watches the specified source folder and automatically converts AsciiDoc documents to the backend format into a target directory.'
  s.authors = ['Paul Rayner', 'Dan Allen']
  s.email = ['paul@virtual-genius.com']
  s.homepage = 'https://github.com/asciidoctor/guard-asciidoc'
  s.license = 'MIT'

  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/asciidoctor/guard-asciidoc/issues',
    'changelog_uri' => 'https://github.com/asciidoctor/guard-asciidoc/blob/main/CHANGELOG.adoc',
    'mailing_list_uri' => 'https://chat.asciidoctor.org',
    'source_code_uri' => 'https://github.com/asciidoctor/guard-asciidoc'
  }

  # NOTE the logic to build the list of files is designed to produce a usable package even when the git command is not available
  begin
    files = (result = `git ls-files -z`.split ?\0).empty? ? Dir['**/*'] : result
  rescue
    files = Dir['**/*']
  end
  s.files = files.grep %r/^(?:lib\/.+|LICENSE|(?:CHANGELOG|README)\.adoc|#{s.name}\.gemspec)$/
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'guard', '~> 2.18.0'
  s.add_dependency 'guard-compat', '~> 1.2.0'
  s.add_dependency 'asciidoctor', '~> 2.0'

  s.add_development_dependency 'rake', '~> 13.0.0'
end
