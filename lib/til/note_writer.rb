module Til
  class NoteWriter
    attr_reader :title

    def initialize title
      @title = title
    end

    def call
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
  end
end
