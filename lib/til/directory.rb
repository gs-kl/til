require 'til/note'

module Til
  class Directory
    attr_reader :path

    def self.from_relative(relative_path)
      self.new(DIRECTORY + relative_path)
    end

    def initialize(path)
      @path = path
    end

    def notes
      note_paths.map do |note_path|
        Note.new(note_path)
      end
    end

    private

    def note_paths
      Dir.glob(path)
    end
  end
end

