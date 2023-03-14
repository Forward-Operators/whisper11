class LiveAudioInput
  def initialize(rec_bin = ENV['REC_BIN'])
    @rec_bin = rec_bin

    raise "rec binary is missing" if @rec_bin.nil?
  end

  def start
    cmdline = "#{@rec_bin} -b 16 -t coreaudio -t .wav - silence 1 1 1% 1 2.2 1% rate 16k pad 0.5 0.5 2>/dev/null"

    while true
      io = IO.popen(cmdline, 'r')
      buffer = io.read

      yield buffer
    end
  end
end
