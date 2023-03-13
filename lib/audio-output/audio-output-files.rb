require 'tempfile'

class AudioOutputFiles
  def initialize(directory_path)
    @directory_path = directory_path

    raise "directory path is missing" if @directory_path.nil?
  end

  def play(audio)
    tmp_file = Tempfile.create(['audio-output-files', '.wav'], @directory_path)
    File.write(tmp_file.path, audio)

    puts "AudioOutputFiles: Audio file saved to #{tmp_file.path}"
  end
end
