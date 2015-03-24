require 'thor'
require 'colorize'
require 'fileutils'
require 'date'
require 'json'

module Til

  class Cli < Thor
    desc "new SUBJECT \"TITLE\"", "Generate a new note with TITLE about SUBJECT. TITLE should be quoted and shell metacharacters escaped."
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

    desc "cat [SUBJECT]", "Print all notes [on SUBJECT]"
    def cat(subject=nil)
      if subject
        Til.print_all_notes_in(subject)
      else
        Til.print_all_notes
      end
    end

    desc "edit [SEARCH TERM]", "Edit file that matches search for [SEARCH TERM]."
    long_desc "`--last` flag"
    option :last, type: :boolean
    def edit(keyword="")
      Til.edit_file(keyword, options)
    end

    desc "git COMMAND", "Run Git COMMAND in TIL directory"
    def git(*args)
      Til.run_git_command(*args)
    end


    desc "grep COMMAND", "Run grep COMMAND in TIL directory"
    def grep(*args)
      Til.run_grep_command(*args)
    end


    desc "ag COMMAND", "Run Silver Searcher COMMAND in TIL directory"
    def ag(*args)
      Til.run_ag_command(*args)
    end

    desc "rm [SEARCH TERM]", "Remove a file matching the search term. Prompts for confirmation."
    def rm(keyword)
      Til.remove_file(keyword)
    end
  end
end
