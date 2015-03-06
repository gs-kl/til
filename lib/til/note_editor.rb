require 'github-markdown-preview' # seems to be slowing things down a lot

module Til
  class NoteEditor
    def initialize(note)
      @path = note.path
    end

    def self.open(note)
      self.new(note)
    end
    
    def edit
      preview = GithubMarkdownPreview::HtmlPreview.new(path)
      preview.watch
      system("open", preview.preview_file)
      system("vim", path)
      preview.end_watch
      preview.delete
    end
  end
end
