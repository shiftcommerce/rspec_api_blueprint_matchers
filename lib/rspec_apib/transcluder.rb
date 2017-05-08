module RSpecApib::Transcluder
  REGEX = /:\[[^\]]*\]\(([^\)]*)\)/
  def self.each_line(file, &block)
    File.readlines(file, encoding: "UTF-8").each do |line|
      if needs_transclude?(line)
        transclude(file, line, &block)
      else
        yield line
      end
    end
  end

  def self.needs_transclude?(line)
    line =~ REGEX
  end

  def self.transclude(file, line, &block)
    line.gsub!(REGEX) do |match|
      transclude_file = $1
      unless transclude_file =~ /^\//
        transclude_file = File.expand_path(transclude_file, File.dirname(file))
      end
      each_line(transclude_file, &block)
      ""
    end
    yield line
  end


end
