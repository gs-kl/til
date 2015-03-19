# require 'github-markdown-preview' #!! seems to be slowing things down a lot if placed in til.rb

module Til
  class NoteEditor
    attr_reader :path

    def initialize(note)
      @path = note.path
    end

    def self.open(note)
      self.new(note)
    end
    
    def edit
      # preview = GithubMarkdownPreview::HtmlPreview.new(path)
      # preview.watch
      # system("open", preview.preview_file)
      system(ENV["EDITOR"] || "vim", path)
      # preview.end_watch
      # preview.delete
    end
  end
end
