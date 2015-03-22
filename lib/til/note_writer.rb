module Til
  class NoteWriter
    attr_reader :title

    def initialize title
      @title = title
    end

    def call(if_modified, if_unmodified)
      temporary_note = TemporaryNote.new
      temporary_note.write("# #{title}\n\n")
      temporary_note.edit(if_modified, if_unmodified)
    end
  end

  class TemporaryNote
    attr_reader :tempfile

    def initialize(tempfile = Tempfile.new(["new_note_content", ".md"]))
      @tempfile = tempfile
    end

    def write(text)
      File.write(path, text)
    end

    def text
      File.read(path)
    end

    def edit(if_modified, if_unmodified)
      original_text = text
      system(ENV["EDITOR"], path)
      modified_text = text
      
      if original_text == modified_text
        if_unmodified.call
      else
        if_modified.call(modified_text)
      end

      finish_editing
    end

    private

    def path
      tempfile.path
    end

    def finish_editing
      tempfile.close
      tempfile.unlink
    end

  end
end
