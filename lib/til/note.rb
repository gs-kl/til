module Til
  class Note
    attr_accessor :path
    def initialize path
      @path = path
    end

    def mtime
      File.mtime(path)
    end

    def subject
      /\/([^\/]+)\/[^\/]+$/.match(path)[1]
    end

    def pretty_printed_mtime
      if date_modified == Date.today
        "today"
      elsif date_modified == (Date.today - 1)
        "yesterday"
      elsif date_modified > (Date.today - 6)
        mtime.strftime("%A")
      else 
        mtime.strftime("%b. %-d, %Y")
      end
    end

    def title
      content[0].gsub("#","").chomp
    end

    def content
      IO.readlines(path)
    end

    def date_modified
      @date_modified ||= mtime.to_date
    end
  end
end
