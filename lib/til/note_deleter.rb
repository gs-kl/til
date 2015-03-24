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
          puts "\"#{note.title.bold}\" deleted.".green
        else
          puts "\"#{note.title.bold}\" not deleted.".red
        end
      rescue Interrupt
        warn "\nAborted!"
        abort
      end
    end

  end
end
