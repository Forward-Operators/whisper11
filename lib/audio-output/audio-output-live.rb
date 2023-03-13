require 'tempfile'

class AudioOutputLive
  def initialize(play_bin = ENV['PLAY_BIN'])
    @play_bin = play_bin

    raise "play binary is missing" if @play_bin.nil?
  end

  def play(audio)
    tmp_file = Tempfile.create('audio-output-live')
    File.write(tmp_file.path, audio)

    cmdline = "#{@play_bin} #{tmp_file.path} 2>/dev/null"

    system cmdline

    File.unlink(tmp_file.path) rescue nil
  end
end