# frozen_string_literal: true

describe Guard::AsciiDoc do
  let(:subject_with_options) { described_class.new run_on_start: true }
  let(:subject_with_watch_dir) { described_class.new watch_dir: 'docs' }
  let(:subject_with_backend) { described_class.new backend: 'docbook' }
  let(:subject_with_unknown_backend) { described_class.new backend: 'jats' }
  let(:subject_with_watchers) { described_class.new watchers: [(Guard::Watcher.new %r/\.asciidoc$/)] }
  let(:subject_with_attributes_as_array) { described_class.new attributes: %w(toc) }
  let(:subject_with_attributes_as_string) { described_class.new attributes: 'toc' }

  before do
    (allow Guard::Compat::UI).to (receive :info)
  end

  describe '#new' do
    context 'when receives option hash' do
      it 'should merge options with default options' do
        (expect subject_with_options.options[:run_on_start]).to be_truthy
      end

      it 'should create default watcher if no watchers are present' do
        watchers = subject.options[:watchers]
        (expect watchers).not_to be_empty
        (expect watchers[0].pattern.to_s).to include 'adoc'
      end

      it 'should create default watcher at specified watch dir if no watchers are present' do
        watchers = subject_with_watch_dir.options[:watchers]
        (expect watchers).not_to be_empty
        (expect watchers[0].pattern.to_s).to include '^docs'
      end

      it 'should not create default watcher if watcher is defined' do
        watchers = subject_with_watchers.options[:watchers]
        (expect watchers).not_to be_empty
        (expect watchers[0].pattern.to_s).to include '.asciidoc'
      end

      it 'should allow Asciidoctor backend to be specified' do
        (expect subject_with_backend.asciidoc_opts).to include ({ backend: 'docbook5' })
      end

      it 'should initialize AsciiDoc attributes Hash and add env-guard entry' do
        (expect subject.asciidoc_opts).to include ({ attributes: { 'env-guard' => '' } })
      end

      it 'should add env-guard to AsciiDoc attributes if specified as an array' do
        (expect subject_with_attributes_as_array.asciidoc_opts).to include ({ attributes: %w(toc env-guard) })
      end

      it 'should add env-guard to AsciiDoc attributes if specified as a string' do
        (expect subject_with_attributes_as_string.asciidoc_opts).to include ({ attributes: 'toc env-guard' })
      end
    end
  end

  describe '#start' do
    context 'by default' do
      it 'should load Asciidoctor but not call #run_all' do
        (expect subject).not_to (receive :run_all)
        subject.start
        (expect defined? Asciidoctor).to be_truthy
      end

      it 'should not fail if gem for backend is not available' do
        (expect subject_with_unknown_backend).not_to (receive :run_all)
        subject_with_unknown_backend.start
      end
    end

    context 'when :run_on_start option set to true' do
      it 'should call #run_all' do
        (expect subject_with_options).to (receive :run_all)
        subject_with_options.start
      end
    end
  end

  describe '#run_all' do
    it 'should rebuild all files being watched' do
      (expect Guard::Compat).to (receive :matching_files).and_return []
      (((allow subject).to (receive :run_on_changes)).with []).and_return []
      subject.run_all
    end
  end

  describe '#run_on_changes' do
    context 'with one file' do
      after do
        File.unlink fixture_file 'test.html'
      end

      it 'should convert file' do
        subject.start
        subject.run_on_changes [(fixture_file 'test.adoc')]
        (expect (Pathname.new fixture_file 'test.html')).to exist
      end
    end

    context 'with one directory' do
      after do
        File.unlink fixture_file 'test.html'
      end

      it 'should convert file' do
        (expect Guard::Compat).to (receive :matching_files).and_return [(fixture_file 'test.adoc')]
        subject.start
        subject.run_on_changes [fixtures_dir]
        (expect (Pathname.new fixture_file 'test.html')).to exist
      end
    end

    context 'failure' do
      it 'should throw :task_has_failed on conversion failure' do
        (allow Guard::Compat::UI).to receive :error
        subject.start
        expect do
          subject.run_on_changes [(fixture_file 'no-such-file.adoc')]
        end.to throw_symbol :task_has_failed
      end
    end
  end
end
