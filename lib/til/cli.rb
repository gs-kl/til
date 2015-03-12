require 'thor'
require 'colorize'
require 'fileutils'
require 'date'
require 'json'

module Til

  class Cli < Thor
    desc "new SUBJECT TITLE", "Generate a new note with TITLE about SUBJECT"
    def new(subject, title)
      Til.new_note(subject, title)
    end

    desc "ls [SUBJECT]", "List all notes [on SUBJECT]"
    def ls(subject = nil)
      if subject
        Til.list_notes_in(subject)
      else
        Til.list_all_notes
      end
    end

    desc "subjects", "List all subjects"
    def subjects
      Til.list_subjects :bullet_points
    end

    desc "pwd", "Print the path of your TIL working directory"
    def pwd
      Til.print_working_directory
    end

    desc "last [QUANTITY]", "Print [QUANTITY] most recent note[s]"
    def last(quantity=1)
      Til.print_most_recent_note quantity.to_i
    end

    desc "open", "Open TIL working directory"
    def open
      Til.open_working_directory
    end

    desc "printall [SUBJECT]", "Print all notes [on SUBJECT]"
    def printall(subject=nil)
      if subject
        Til.print_all_notes_in(subject)
      else
        Til.print_all_notes
      end
    end


    desc "editlast", "Edit most recently modified note"
    def editlast
      Til.open_preview_and_edit(Directory.root.notes.most_recent)
    end


    desc "edit [SEARCH TERM]", "Edit file that matches search for [SEARCH TERM]. If multiple results, can select."
    def edit(keyword)
      Til.edit_file(keyword)
    end




    # def cd
    # def git
    # def cat
    # def pwd
    # def grep
    # def tree
    # def github
    # def open    last, specific title

  end
end
