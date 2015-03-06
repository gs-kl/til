module Til
  class NoteList
    attr_accessor :notes
    delegate :push, to: :notes

    def initialize(notes=Array.new)
      @notes = notes
    end

    def sort_by_modified_time
      notes.sort { |a, b| b.mtime <=> a.mtime }
    end

    def most_recent
      notes.sort { |a, b| b.mtime <=> a.mtime }.fetch(0)
    end
  end
end
