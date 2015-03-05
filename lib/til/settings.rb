require 'pathname'

module Til
  CONFIG_DIRECTORY = File.expand_path("~/.til")

  class Settings
    settings_file = File.read(CONFIG_DIRECTORY + "/config.json")
    @@settings = JSON.parse(settings_file)

    def self.directory
      if Pathname.new(@@settings["directory"]).relative?
        File.expand_path @@settings["directory"]
      else
        @@settings["directory"]
      end
    end
  end

  DIRECTORY = Settings.directory

  HIGHLIGHT_COLORS = {
      0 => :yellow,
      1 => :cyan,
      2 => :green,
      3 => :blue,
    }
end
