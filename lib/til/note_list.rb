module Til

  class NoteList
    attr_accessor :notes

    def initialize(notes=Array.new)
      @notes = notes
    end

    def sort_by_modified_time
      notes.sort { |a, b| b.mtime <=> a.mtime }
    end

    def most_recent
      notes.sort { |a, b| b.mtime <=> a.mtime }.fetch(0)
    end



    def push arg
      self.notes.send(:push, arg)
    end
    def each &block
      self.notes.send(:each, &block)
    end
    def empty?
      self.notes.send(:empty?)
    end
    def length
      self.notes.send(:length)
    end

  end
end