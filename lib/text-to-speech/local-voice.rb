require 'tempfile'

class LocalVoice
  def initialize(voice_name = "Zosia", lame_bin = ENV['LAME_BIN'])
    @voice_name = voice_name
    @lame_bin = lame_bin

    raise "voice name is missing" if @voice_name.nil?
    raise "lame is missing" if @lame_bin.nil? or !File.exists?(@lame_bin)
  end

  # outputs mp3 buffer
  # TODO: fix those sad tmp file hacks
  def synthesize(text)
    tmp_aiff_file = Tempfile.create(['local-voice', '.aiff'])
    tmp_mp3_file = Tempfile.create(['local-voice', '.mp3'])

    cmdline = "say -v \"#{@voice_name}\" -o #{tmp_aiff_file.path}"

    say_command = IO.popen(cmdline, 'r+')
    say_command.write(text)

    system("#{@lame_bin} #{tmp_aiff_file.path} #{tmp_mp3_file.path} 2>/dev/null")

    File.read(tmp_mp3_file.path)
  end
end
