require 'openai'
require 'awesome_print'

require 'tempfile'

class OpenAIWhisper
  def initialize(access_token = ENV['OPENAI_ACCESS_TOKEN'])
    @access_token = access_token

    raise "whisper openai access token is missing" if @access_token.nil?
  end

  def process(audio)
    openai = OpenAI::Client.new

    tmpfile = Tempfile.create(['openai-whisper', '.mp3'])
    File.write(tmpfile.path, audio)

    response = openai.transcribe(
      parameters: {
          model: "whisper-1",
          file: File.open(tmpfile.path),
      })

    response.parsed_response['text']
  end
end
