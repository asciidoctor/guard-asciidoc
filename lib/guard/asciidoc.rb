# frozen_string_literal: true

require 'guard/compat/plugin'
autoload :Pathname, 'pathname'

module Guard
  class AsciiDoc < Plugin
    BACKEND_ALIASES = { 'html' => 'html5', 'docbook' => 'docbook5' }
    DEFAULT_BACKEND = 'html5'
    DEFAULT_OPTIONS = {
      watch_dir: '.',
      watch_ext: %w(adoc),
      watch_hidden: false,
      run_on_start: false,
      always_build_all: false,
    }
    FILE_SEPARATOR = ::File::SEPARATOR
    PLUGIN_KEYS = [:any_return, :group, :watchers]
    CONFIG_KEYS = DEFAULT_OPTIONS.keys

    attr_reader :asciidoc_opts

    def initialize options = {}
      compiled_opts = DEFAULT_OPTIONS.merge
      compiled_opts[:watch_dir] = (options.delete :watch_dir) || '.' if options.key? :watch_dir
      compiled_opts.merge! options
      compiled_opts[:watch_dir] = '.' if compiled_opts[:watch_dir].to_s.empty?
      @asciidoc_opts = compiled_opts.except(*(PLUGIN_KEYS + CONFIG_KEYS))
      unless (@asciidoc_opts[:backend] = BACKEND_ALIASES[(backend = @asciidoc_opts[:backend])] || backend)
        @asciidoc_opts[:backend] = DEFAULT_BACKEND
      end
      (@asciidoc_opts[:attributes] ||= {})['env-guard'] = ''
      @asciidoc_opts[:safe] ||= :unsafe
      if (compiled_opts[:watchers] ||= []).empty? && (watch_dir = compiled_opts[:watch_dir])
        watch_dir = compiled_opts[:watch_dir] = (::Pathname.new watch_dir).cleanpath.to_s
        watch_re = watch_dir == '.' ? '' : %(^#{::Regexp.escape watch_dir}(?=#{FILE_SEPARATOR}))
        watch_re += compiled_opts[:watch_hidden] ? '.+?' : %((?:[^#{FILE_SEPARATOR}]|#{FILE_SEPARATOR}[^.])+?)
        watch_re += %((?:#{compiled_opts[:watch_ext].join '|'})$)
        watch_rx = ::Regexp.new watch_re
        compiled_opts[:watchers] = [(Watcher.new watch_rx)]
      end
      super compiled_opts
    end

    def start
      Compat::UI.info 'Guard::AsciiDoc is now watching files'
      require 'asciidoctor'
      require %(asciidoctor-#{asciidoc_opts[:backend]}) unless ::Asciidoctor::Converter.for asciidoc_opts[:backend]
      if (requires = asciidoc_opts.delete :requires)
        Array(requires).each {|require_| require require_ }
      end
      run_all if options[:run_on_start]
    end

    def run_all
      run match_all, force: true
    end

    def run_on_changes paths
      options[:always_build_all] ? run_all : (run paths)
    end

    alias run_on_additions run_on_changes
    alias run_on_modifications run_on_changes

    private

    def run paths, force: nil
      paths.each do |filepath|
        if ::File.directory? filepath
          run (match_all filepath), force: true
        else
          convert_asciidoc filepath, asciidoc_opts, force: force
        end
      end
      true
    end

    def convert_asciidoc filepath, opts, force: nil
      Compat::UI.info %(Converting#{force ? '' : ' changed'} file: #{filepath})
      if (to_dir = opts[:to_dir])
        filepath_segments = (::Pathname.new filepath).each_filename.to_a
        if (watch_dir = options[:watch_dir]) != '.' && watch_dir == filepath_segments[0]
          to_dir = File.join [to_dir] + (filepath_segments.slice 1...-1)
        else
          to_dir = File.join [to_dir] + (filepath_segments.slice 0...-1)
        end
      end
      ::Asciidoctor.convert_file filepath, (to_dir ? (opts.merge mkdirs: true, to_dir: to_dir) : opts)
    rescue => e
      Compat::UI.error e.message
      raise :task_has_failed
    end

    def match_all from = nil
      glob = from ? (::File.join from, '**', '*.*') : (::File.join '**', '*.*')
      (Compat.matching_files self, ::Dir[glob]).select {|it| ::File.file? it }
    end
  end
end
