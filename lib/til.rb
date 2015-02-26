require "til/version"
require 'til/cli'

module Til
  DEFAULT_DIRECTORY = File.expand_path("~/.til")

  def self.new_note(subject, title)


    # Should do these things only if changes saved to the temp file!
    #
    # subject_path = DEFAULT_DIRECTORY + "/#{subject.downcase}"
    # if !File.directory? subject_path
    #   FileUtils.mkdir(subject_path)
    #   puts "Created a new directory for #{subject.downcase}"
    # end

  end

  def self.list_notes_in(subject)
    notes = Dir.glob(DEFAULT_DIRECTORY + "/#{subject}/*.md")   
    if notes.empty?
      puts "You don't seem to have any notes on that subject!"
      puts "You DO have notes on the following subjects:"
      subjects = Array.new
      Dir.glob(DEFAULT_DIRECTORY + "/*").each do |dirname|
        subjects.push dirname.gsub(DEFAULT_DIRECTORY + "/", "")
      end
      puts subjects.join(", ")
    else
      Til.print_all notes
    end
  end

  def self.list_all_notes
    Til.print_all Dir.glob(DEFAULT_DIRECTORY + "/**/*.md")
  end

  def self.print_all notes
    notes.each do |note|
      directory = /\/([^\/]+)\/[^\/]+$/.match(note)[1]
      lines = IO.readlines(note)
      puts directory + ": " + Til.strip_markdown(lines[0].chomp).blue.underline + "  " + File.mtime(note).strftime("(%A, %b. %-d, %Y)").cyan
    end
  end

  def self.strip_markdown line
    line.gsub("#","").strip
  end
end
