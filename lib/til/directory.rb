require 'til/note'

module Til
  class Directory
    attr_reader :path

    def initialize(subject=nil)
      if subject
        @path = DIRECTORY + "/#{subject}/*.md"
      else
        @path = DIRECTORY + "/**/*.md"
      end
    end

    def self.root
      self.new
    end

    def self.for(subject)
      self.new(subject)
    end

    def notes
      note_list = NoteList.new
      note_paths.each do |note_path|
        note_list.push Note.new(note_path)
      end
      note_list
    end

    private

    def note_paths
      Dir.glob(path)
    end
  end
end
