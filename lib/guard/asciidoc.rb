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
      paths.each do |file_path|
        UI.info "Change detected in " + file_path
#        binding.pry
        Asciidoctor.render_file(file_path, :in_place => true)
        # Asciidoctor.render_file(path, :in_place => true, :attributes => {'stylesdir' => 'styles', 'stylesheet' => 'github.css'})
      end
    end
  end
end