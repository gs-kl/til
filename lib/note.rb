module Til
  class Note
    attr_accessor :path, :mtime, :subject
    def initialize path, mtime, subject
      @path = path
      @mtime = mtime
      @subject = subject
    end

    def pretty_printed_mtime
      if mtime.strftime("%d-%b-%Y") == Date.today.strftime("%d-%b-%Y")
        "today"
      elsif mtime.strftime("%d-%b-%Y") == (Date.today - 1).strftime("%d-%b-%Y")
        "yesterday"
      elsif mtime.strftime("%d-%b-%Y") > (Date.today - 6).strftime("%d-%b-%Y")
        mtime.strftime("%A")
      else 
        mtime.strftime("%b. %-d, %Y")
      end
    end

    def title
      lines = IO.readlines(path)
      lines[0].gsub("#","").chomp
    end

    def content
      IO.readlines(path)
    end
  end
end
