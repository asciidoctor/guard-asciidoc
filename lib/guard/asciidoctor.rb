require 'guard/guard'
require 'asciidoctor'

module Guard
  class Asciidoctor < Guard
    def start
      UI.info "Guard::Asciidoctor has started watching your files"
    end

    def run_all
      true
    end

    def run_on_change(paths)
      paths.each do |path|
        UI.info "Change detected in " + path
        Asciidoctor.render_file(path, :in_place => true)
      end
    end
  end
end