class LocalWhisper
  def initialize(whisper_bin: ENV['WHISPER_BIN'], model: ENV['WHISPER_MODEL'], language: 'en')
    @whisper_bin = whisper_bin
    @model = model
    @language = language

    raise "whisper binary is missing" if @whisper_bin.nil?
    raise "whisper model is missing" if @model.nil?
  end

  def process(audio)
    cmdline = "#{@whisper_bin} -m #{@model} -l #{@language} -t 8 -nt 0 -f - 2>/dev/null"

    io = IO.popen(cmdline, 'r+')
    io.write(audio)
    io.close_write

    data = io.read

    data.gsub!(/^\s+/, '')
    data.gsub!(/\s+$/, '')

    data
  end
end
