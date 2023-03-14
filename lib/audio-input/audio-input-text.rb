require './lib/text-to-speech/local-voice'

# generates voice files with text prompts
class TextAudioInput
  def initialize(texts: [], synthesizer: LocalVoice.new)
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
