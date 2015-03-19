module Til
  class NoteFinder < Thor
    include Thor::Actions

    attr_reader :search_term

    def initialize(search_term)
      @search_term = search_term
      @matches = NoteList.new
      Directory.root.notes.each do |note|
        if note.title.include?(keyword)
          @matches.push note
        end
      end
    end

    def self.find(search_term)
      self.new(search_term)
    end
  end
end
