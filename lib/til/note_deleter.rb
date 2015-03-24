module Til
  class NoteDeleter
    include Thor::Base
    include Thor::Actions

    def initialize(note)
      @note = note
    end

    def self.delete(note)
      note_to_delete = self.new(note)
      begin
        choice = ask("Really delete #{note_to_delete}? (y/n) ")
        if (choice == "y") || (choice == "yes")
          File.delete(note_to_delete.path)
        else
          puts "File not deleted.".red
        end
      rescue Interrupt
        warn "\nAborted!"
        abort
      end
    end
  end
end
