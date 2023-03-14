#!/usr/bin/env ruby

require 'rubygems'

# load .env file with environment variables
# see .env.example for... examples.
require 'dotenv/load'

# runs chat through its basic flow
require './lib/helpers/chat-orchestrator'

# wrapper around openai gem
require './lib/chat/openai-chat'

# live audio input using rec command from sox
require './lib/audio-input/audio-input-live'

# this makes testing easier by allowing to use pre-recorded audio
# 
#   audio_input: FilesAudioInput.new("../data/audio")
# 
# parameter that will sequentially feed wav audio files from given directory
# as if they were recorded live and process the rest without any changes
require './lib/audio-input/audio-input-files'

# text audio input so it's like audio-input-files, but
# generates audio data from text on the fly
# require './lib/audio-input/audio-input-text'

# playing generated audio with mpg123
require './lib/audio-output/audio-output-live'

# generated parts of the conversation can also be saved as audio files
# instead of being emitted live
# require './lib/audio-output/audio-output-files'

# use elevenlabs.io to generate audio from text
require './lib/text-to-speech/eleven-labs'

# use local voice to generate audio from text (uses "say" command from macOS)
# require './lib/text-to-speech/local-voice'

# use local whisper.cpp installation to process audio into speech
#require './lib/speech-to-text/local-whisper'

# use whisper through OpenAI API
require './lib/speech-to-text/openai-whisper'

chat = ChatOrchestrator.new(
  # this generates audio for sequence of prompts
  # audio_input: TextAudioInput.new(texts: ['Tell me a terrible joke about LLMs', 'No dobra, powiedz jakiś lepszy.']),

  # this uses sox to record audio from microphone (breaks for silence)
  audio_input: LiveAudioInput.new,

  # this will feed audio files from given directory as if they were recorded live,
  # audio_input: FilesAudioInput.new("../data/audio"),

  # Local whisper uses your local installation of whisper.cpp
  # speech_to_text: LocalWhisper.new,
  speech_to_text: OpenAIWhisper.new,

  # takes some additional optional parameters:
  chat_engine: OpenAIChat.new(temperature: 0.7, max_tokens: 256, model: "gpt-3.5-turbo"),
  # chat_engine: OpenAIChat.new,

  text_to_speech: ElevenLabs.new,

  audio_output: AudioOutputLive.new,
  # audio_output: AudioOutputFiles.new("/tmp/whisper11")
)

chat.start!