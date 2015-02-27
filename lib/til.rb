require "til/version"
require 'til/cli'

module Til
  DEFAULT_DIRECTORY = File.expand_path("~/.til")

  def self.new_note(subject, title)
    temp_file = Tempfile.new("new_note_content")
    File.write(temp_file.path, "# #{title}\n\n")
    original_text = File.read(temp_file.path)
    system("vim", temp_file.path)
    modified_text = File.read(temp_file.path)
    temp_file.close
    temp_file.unlink

    if original_text != modified_text
      subject_path = DEFAULT_DIRECTORY + "/#{subject.downcase}"
      if !File.directory? subject_path
        FileUtils.mkdir(subject_path)
        puts "Created a new directory for #{subject.downcase}"
      end
      file_path = subject_path + "/" + title.downcase.gsub(" ", "-") + ".md"
      write_file = File.new(file_path, "w")
      write_file.puts modified_text
      write_file.close
    else
      puts "You didn't write anything in the file, so it wasn't created.".red
    end
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
    notes = Dir.glob(DEFAULT_DIRECTORY + "/**/*.md")
    notes_and_mtimes = notes.map do |note_path|
      [note_path, File.mtime(note_path)]
    end
    notes_and_mtimes.sort! {|x,y| y[1] <=> x[1]}

    subjects_seen = Array.new
    subject_colors = {
      0 => :red,
      1 => :cyan,
      2 => :magenta,
      3 => :green
    }

    puts "Listing all #{notes_and_mtimes.length} notes:".green.underline
    notes_and_mtimes.each do |element|
      note_path = element[0]
      mtime = element[1]
      subject = /\/([^\/]+)\/[^\/]+$/.match(note_path)[1]

      subjects_seen.push(subject) unless subjects_seen.include?(subject)
      index = subjects_seen.index subject
      color = subject_colors[index]

      date_modified = if mtime.strftime("%d-%b-%Y") == Date.today.strftime("%d-%b-%Y")
          "today"
        elsif mtime.strftime("%d-%b-%Y") == (Date.today - 1).strftime("%d-%b-%Y")
          "yesterday"
        elsif mtime.strftime("%d-%b-%Y") > (Date.today - 6).strftime("%d-%b-%Y")
          mtime.strftime("%A")
        else 
          mtime.strftime("%b. %-d, %Y")
        end

      lines = IO.readlines(note_path)
      puts subject.colorize(color).underline + ":\t" + Til.strip_markdown(lines[0].chomp).bold + " (" + date_modified + ")"
    end
  end



  def self.print_all notes
    notes.each do |note|
      directory = /\/([^\/]+)\/[^\/]+$/.match(note)[1]
      lines = IO.readlines(note)
      puts directory + ": " + Til.strip_markdown(lines[0].chomp).blue + "  " + File.mtime(note).strftime("(%A, %b. %-d, %Y)")
    end
  end

  def self.strip_markdown line
    line.gsub(/#/,"").strip
  end
end
