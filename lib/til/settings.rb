require 'pathname'

module Til
  class Settings
    attr_reader :settings

    def initialize(config_file)
      @settings = JSON.parse(File.read(config_file))
    end

    def self.load
      self.new(File.expand_path("~/.til/config.json"))
    end

    def directory
      File.expand_path(settings["directory"])
    end
  end
end
