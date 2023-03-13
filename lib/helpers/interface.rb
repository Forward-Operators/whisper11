class UI
  def self.clear_status
    STDOUT.write " " * 78 + "\r"
  end
  
  def self.report_status(icon, text)
    clear_status
    STDOUT.write "#{icon} #{text}...\r"
  end
  
  def self.report_understood_speech(text)
    clear_status
  
    if text.empty?
      STDOUT.write "👂 ⚠️ nieczyt?!!@//one\n"
    else
      STDOUT.write "👂 #{text.colorize(:blue)}\n"
    end
  end
  
  def self.report_generated_text(text)
    clear_status
  
    if text.empty?
      STDOUT.write "🤖 [no response]\r"
    else
      STDOUT.write "🤖 #{text.colorize(:green)}\n"
    end
  end  
end