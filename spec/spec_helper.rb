# frozen_string_literal: true

require 'guard/compat/test/helper'
require 'guard/asciidoc'

module Guard
  class Watcher
    attr_reader :pattern
    def initialize pattern
      @pattern = pattern
    end
  end
end

RSpec.configure do |config|
  def fixtures_dir
    File.join __dir__, 'fixtures'
  end

  def fixture_file path
    File.join fixtures_dir, path
  end
end
