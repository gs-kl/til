module Til
  class NoteDeleter
    include Thor::Base
    include Thor::Actions
    attr_reader :note

    def initialize(note)
      @note = note
    end

    def delete
      begin
        choice = ask("Really delete \"#{note.title.bold}\" (in #{note.subject.bold})? (y/n)")
        if (choice == "y") || (choice == "yes")
          File.delete(note.path)
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
