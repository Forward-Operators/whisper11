require './lib/helpers/conversation'
require './lib/helpers/interface'
require './lib/helpers/prompt-generator'

class ChatOrchestrator
  def initialize(audio_input:, speech_to_text:, chat_engine:, text_to_speech:, audio_output:)
    @audio_input = audio_input
    @speech_to_text = speech_to_text
    @chat_engine = chat_engine
    @text_to_speech = text_to_speech
    @audio_output = audio_output

    @conversation = Conversation.new
    @prompt_generator = PromptGenerator.new(@conversation)

    raise "No audio input" unless @audio_input
    raise "No speech to text" unless @speech_to_text
    raise "No chat engine" unless @chat_engine
    raise "No text to speech" unless @text_to_speech
  end

  def start!
    UI.report_status('🎙️', 'listening')

    # let's loop through audio chunks we've detected worth considering as sentences
    @audio_input.start do |audio_buffer|
      UI.report_status('🤫', 'whisper processing')
      
      # use speech to text engine to convert audio buffer we've received to text
      speech_text = @speech_to_text.process(audio_buffer)
        
      if speech_text.nil? || speech_text.empty?
        # we might have not understood what the user said, let's invite them to try again
        ask_to_repeat
      else
        # give feedback by displaying what we've understood
        UI.report_understood_speech(speech_text)

        # let's remember what the user said for future context
        @conversation.remember_my_statement(speech_text)

        # let's generate a response from chat engine
        UI.report_status('🧠', 'generating response text')
        response_text = @chat_engine.ask(@prompt_generator.generate)
            
        if response_text.empty?
          # if we couldn't generate a response, let's try again
          ask_to_repeat("What do you mean?")
        else
          # we've generated something, let's just say it
          say(response_text)

          # and remember for future context as well
          @conversation.remember_generated_statement(response_text)
        end    
      end

      UI.report_status('🎙️', 'listening')
    end  
  end

  private

  # if report_generated_text is set to false, then we won't remember we said that
  # and also won't display in the UI explicitly that we're generating that audio
  # useful for errors, asking to repeat and some such
  def say(text, report_generated_text=true)
    UI.report_status('🦜', 'converting to audio') if report_generated_text

    speech_audio = @text_to_speech.synthesize(text)    

    UI.report_generated_text(text) if report_generated_text

    @audio_output.play(speech_audio)
  end

  def ask_to_repeat(text="Say that again, please?")
    say(text, false)
  end

end
