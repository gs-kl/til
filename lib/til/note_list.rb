module Til

  class NoteList
    include Thor::Actions
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

    def filter
      if notes.length == 1
        notes.first
      else
        notes.each_with_index do |note, index|
          puts "#{index+1}) #{note.title}"
        end
        choice = ask("Choice: ").to_int
        notes.fetch(choice-1){puts "invalid choice"}
      end
    end


    def push arg
      self.notes.send(:push, arg)
    end
    def each &block
      self.notes.send(:each, &block)
    end
    def each_with_index &block
      self.notes.send(:each_with_index, &block)
    end
    def empty?
      self.notes.send(:empty?)
    end
    def length
      self.notes.send(:length)
    end
    def first
      self.notes.send(:first)
    end

  end
end
