# helps to debug what's going on over HTTP
# RestClient.log = 'stdout'

require 'awesome_print'
require 'rest-client'

class ElevenLabs
  def initialize(api_key = ENV['ELEVEN_LABS_API_KEY'], default_voice_id = ENV['ELEVEN_LABS_DEFAULT_VOICE_ID'])
    @base_url = 'https://api.elevenlabs.io/v1'
    @api_key = api_key
    @default_voice_id = default_voice_id

    raise "ELEVEN_LABS_API_KEY key is missing" if @api_key.nil?
    raise "ELEVEN_LABS_DEFAULT_VOICE_ID key is missing" if @api_key.nil?
  end

  def voices
    get("#{@base_url}/voices")
  end

  def user_info
    get("#{@base_url}/user")
  end

  def synthesize(text, voice_id = @default_voice_id)
    url = "#{@base_url}/text-to-speech/#{voice_id}"
    
    data = {
      "text": text,
      "voice_settings": {
        "stability": 0,
        "similarity_boost": 0
      }
    }

    begin
      response = RestClient.post url, data.to_json, {'xi-api-key' => @api_key, content_type: :json}

      return response.body
    rescue Exception => e
      puts "ElevenLabs: Error: #{e.message}"
      ap e
    end

  end

  private
  
  def get
    response = RestClient::Request.execute(
      method: :get,
      url: url,
      headers: {
        'xi-api-key': @api_key
      }
    )

    JSON.parse(response.body)
  end
end
