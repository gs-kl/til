require "til/version"
require 'til/cli'
require 'til/settings'
require 'til/note'
require 'til/directory'
require 'til/note_writer'
require 'til/note_list'
require 'til/note_editor'
require 'til/note_deleter'


module Til
  def self.print_working_directory
    puts Settings.directory
  end

  def self.open_working_directory
    system("open", Settings.directory)
  end

  def self.new_note(subject, title)
    if_unmodified = Proc.new do
      puts "You didn't write anything, so a note wasn't created.".red
      return
    end

    if_modified = Proc.new do |note_content|
      subject_path = DIRECTORY + "/#{subject.downcase}"
      if !File.directory? subject_path
        FileUtils.mkdir(subject_path)
        puts "Created a new directory for #{subject.downcase}"
      end
      file_path = subject_path + "/" + title.downcase.gsub(" ", "-") + ".md"

      write_file = File.new(file_path, "w")
      write_file.write note_content
      write_file.close
      puts "You created a new note in ".green + subject.green.bold + ". `til last` to read it, or `til editlast` to edit it.".green
    end

    NoteWriter.new(title).call(if_modified, if_unmodified)
  end


  def self.search_results_for(search_terms)
    matches = NoteList.new
    Directory.root.notes.each do |note|
      if note.title.downcase.include?(search_terms.downcase)
        matches.push note
      end
    end
    matches
  end


  def self.edit_file(search_term)
    matches = Til.search_results_for(search_term)
    if matches.length < 1
      puts "no matches"
    else
      system(ENV["EDITOR"] || "vim", matches.filter.path)
    end
  end

  def self.remove_file(search_term)
    matches = Til.search_results_for(search_term)
    if matches.length < 1
      puts "no matches"
    else
      NoteDeleter.delete(matches.filter)
    end
  end

  def self.run_git_command(*args)
    system("git --git-dir=#{Settings.directory}/.git --work-tree=#{Settings.directory} #{args.join(" ")}")
  end

  def self.run_grep_command(*args)
    system("grep -r #{args.join(" ")} #{Settings.directory}")
  end

  def self.run_ag_command(*args)
    system("ag #{args.join(" ")} #{Settings.directory}")
  end
 

  def self.print_most_recent_note quantity
    Directory.root.notes.sort_by_modified_time.take(quantity).each {|note| Til.print note}
  end

  def self.print_all_notes
    Directory.root.notes.each {|note| Til.print note}
  end

  def self.print_all_notes_in(subject)
    Directory.for(subject).notes.each {|note| Til.print note}
  end

  def self.list_notes_in(subject)
    notes = Directory.for(subject).notes
    if notes.empty?
      puts "You don't seem to have any notes on that subject!"
      puts "You DO have notes on the following subjects:"
      Til.list_subjects :flat
    else
      Til.enumerate notes
    end
  end

  def self.list_subjects(list_style=:bullet_points)
    subjects = Array.new
    Dir.glob(DIRECTORY + "/*").each do |dirname|
      subjects.push dirname.gsub(DIRECTORY + "/", "")
    end
    if list_style==:flat
      puts subjects.join(", ")
    else
      subjects.each {|subject| puts "- #{subject}"}
    end
  end


  def self.list_all_notes
    notes = Directory.root.notes.sort_by_modified_time
    puts "Listing all #{notes.length} notes: "
    Til.enumerate notes
  end

  def self.print note
    puts note.subject.underline + ":\t" + note.title.bold + " (" + note.pretty_printed_mtime + ")"
    puts note.content
  end

  def self.enumerate notes
    subjects_seen = Array.new
    longest_subject_length = notes.sort_by{|note| note.subject.length}.last.subject.length
    notes.each do |note|
      subjects_seen.push(note.subject) if !subjects_seen.include?(note.subject)
      color_index = subjects_seen.index(note.subject) % HIGHLIGHT_COLORS.length
      color = HIGHLIGHT_COLORS[color_index]
      spacing = " " * (longest_subject_length - note.subject.length)
      puts note.subject.colorize(color) + ":" + spacing + note.title.bold + " (" + note.pretty_printed_mtime + ")"
    end
  end
end
