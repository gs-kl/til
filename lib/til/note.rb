module Til
  class Note
    attr_accessor :path, :mtime, :subject
    def initialize path, mtime, subject
      @path = path
      @mtime = mtime
      @subject = subject
    end

    def pretty_printed_mtime
      if mtime.to_date == Date.today
        "today"
      elsif mtime == (Date.today - 1)
        "yesterday"
      elsif mtime > (Date.today - 6)
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
  end
end
