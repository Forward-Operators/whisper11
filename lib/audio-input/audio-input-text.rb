require './lib/text-to-speech/local-voice'

# generates voice files with text prompts
class TextAudioInput
  # daniel is nice British English voice
  def initialize(texts: [], synthesizer: LocalVoice.new(voice_name: 'Daniel'))
    @texts = texts
    @synthesizer = synthesizer

    raise "synthesizer is missing" if @synthesizer.nil?
  end

  def start
    @texts.each do |text|
      yield @synthesizer.synthesize(text)
    end
  end
end
