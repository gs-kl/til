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

    def filter
      if @matches.length == 1
        @matches.first
      else
        @matches.each_with_index do |note, index|
          puts "#{index+1}) #{note.title}"
        end
        choice = ask("Choice: ")
        puts choice
        @matches.fetch(choice-1)
      end
    end

  end
end
