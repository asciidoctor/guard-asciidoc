require 'guard/guard'
require 'asciidoctor'
require 'pry'

module Guard
  class Asciidoc < Guard
    def start
      UI.info "Guard::Asciidoc has started watching your files"
    end

    def run_all
      true
    end

    def run_on_change(paths)
      puts "Got here..."
      paths.each do |path|
        UI.info "Change detected in " + path
        # start a REPL session
        binding.pry
        Asciidoctor.render_file(path, :in_place => true)
        # Asciidoctor.render_file(path, :in_place => true, :attributes => {'stylesdir' => 'styles', 'stylesheet' => 'github.css'})
        puts "Rendered AsciiDoc to HTML"
      end
    end
  end
end