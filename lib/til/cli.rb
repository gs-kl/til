require 'thor'
require 'colorize'
require 'fileutils'

module Til
  class Cli < Thor
    desc "new SUBJECT TITLE", "Generate a new note with TITLE about SUBJECT"
    def new(subject, title)
      Til.new_note(subject, title)
    end

    desc "ls [SUBJECT]", "List all notes (for SUBJECT)"
    def ls(subject = nil)
      if subject
        Til.list_notes_in(subject)
      else
        Til.list_all_notes
      end
    end
  end
end
