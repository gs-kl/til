require "til/version"
require 'til/cli'
require 'til/settings'
require 'til/note'

module Til

  def self.write_note title
    temp_file = Tempfile.new("new_note_content")
    File.write(temp_file.path, "# #{title}\n\n")
    original_text = File.read(temp_file.path)
    system("vim", temp_file.path)
    modified_text = File.read(temp_file.path)
    temp_file.close
    temp_file.unlink

    if modified_text != original_text
      modified_text
    else
      return nil
    end
  end


  def self.print_working_directory
    puts Settings.directory
  end

  def self.new_note(subject, title)
    note_content = Til.write_note title

    if note_content.nil?
      puts "You didn't write anything, so a note wasn't created.".red
      return
    end

    subject_path = DIRECTORY + "/#{subject.downcase}"
    if !File.directory? subject_path
      FileUtils.mkdir(subject_path)
      puts "Created a new directory for #{subject.downcase}"
    end
    file_path = subject_path + "/" + title.downcase.gsub(" ", "-") + ".md"

    write_file = File.new(file_path, "w")
    write_file.write note_content
    write_file.close
    puts "You created a new note in ".green + subject.green.bold + ". `til last` to read it.".green
  end




  def self.fetch_notes_in relative_path
    Dir.glob(DIRECTORY + relative_path).map do |note_path|
      Note.new(note_path, File.mtime(note_path), /\/([^\/]+)\/[^\/]+$/.match(note_path)[1])
    end.sort! {|x,y| y.mtime <=> x.mtime}
  end




  def self.print_most_recent_note
    note = (Til.fetch_notes_in "/**/*.md")[0]
    Til.print note
  end



  def self.print_all_notes
  end

  def self.print_notes_in(subject)
  end



  def self.list_notes_in(subject)
    notes = Til.fetch_notes_in "/#{subject}/*.md"
    if notes.empty?
      puts "You don't seem to have any notes on that subject!"
      puts "You DO have notes on the following subjects:"
      Til.list_subjects :flat
    else
      Til.enumerate notes
    end
  end



  # should have number of items in each

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
    notes = Til.fetch_notes_in "/**/*.md"
    puts "Listing all #{notes.length} notes:".underline
    Til.enumerate notes
  end

  def self.print note
    puts note.subject.underline + ":\t" + note.title.bold + " (" + note.pretty_printed_mtime + ")"
    puts note.content
  end

  def self.enumerate notes
    subjects_seen = Array.new
    notes.each do |note|
      subjects_seen.push(note.subject)
      color_index = subjects_seen.index(note.subject) % HIGHLIGHT_COLORS.length
      color = HIGHLIGHT_COLORS[color_index]
      puts note.subject.colorize(color).underline + ":\t" + note.title.bold + " (" + note.pretty_printed_mtime + ")"
    end
  end
end
