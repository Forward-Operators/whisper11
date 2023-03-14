require 'tempfile'

class LocalVoice
  def initialize(voice_name: "Zosia", lame_bin: ENV['LAME_BIN'])
    @voice_name = voice_name
    @lame_bin = lame_bin

    raise "voice name is missing" if @voice_name.nil?
    raise "lame is missing" if @lame_bin.nil? or !File.exist?(@lame_bin)
  end

  # outputs mp3 buffer
  # TODO: fix those sad tmp file hacks
  def synthesize(text)
    tmp_aiff_file = Tempfile.create(['local-voice', '.aiff'])
    tmp_mp3_file = Tempfile.create(['local-voice', '.mp3'])

    cmdline = "say -v \"#{@voice_name}\" -o #{tmp_aiff_file.path} 2>/dev/null"

    say_command = IO.popen(cmdline, 'r+')
    say_command.sync = true
    say_command.write(text)
    say_command.close

    system("#{@lame_bin} #{tmp_aiff_file.path} #{tmp_mp3_file.path} 2>/dev/null")

    File.read(tmp_mp3_file.path)
  end
end
