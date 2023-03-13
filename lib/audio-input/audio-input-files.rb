class FilesAudioInput
  def initialize(directory_path)
    @directory_path = directory_path

    raise "directory path is missing" if @directory_path.nil?
  end

  def start
    Dir.glob(File.join(@directory_path, "*.*")).each do |file|
      yield File.read(file)
    end
  end
end
