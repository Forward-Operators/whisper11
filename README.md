# whisper11
Whisper, ChatGPT and Eleven Labs Voice walk into a bar...

[![Short demo video](https://img.youtube.com/vi/45fSHpoOKmo/0.jpg)](https://www.youtube.com/watch?v=45fSHpoOKmo)

## What is this
This is a very quick and dirty integration between [OpenAI Whisper](https://openai.com/research/whisper) speech-to-text, [ChatGPT](https://openai.com/blog/chatgpt) and [Eleven Labs](https://beta.elevenlabs.io) text-to-speech technology.

It can use local Whisper model running locally (using Georgi Gerganov's amazing [whisper.cpp](https://github.com/ggerganov/whisper.cpp)) or use OpenAI API. As a fallback for Eleven Labs Voice, it can use local macOS `say` command.

It also has a very naive (but functioning) concept of context it is able to keep between statements by extending the prompt ChatGPT is given with each iteration.

NOTE: This is an extremely early version (as of now, just a couple of hours of work), so use at your own peril!

## How to use

### Requirements

This assumes you are running on a relatively fresh copy of macOS.

1. Clone the repo.
2. Use `bundle install` command in the repo directory to install dependencies.
3. Install [Homebrew](https://brew.sh/) (or equivalent package manager).
4. With it, install: mpg123, lame, and sox.
5. Copy `.env.example` to `.env` and fill in the values. More directions in the file.

If you wish to run Whisper locally with whisper.cpp, follow their instructions [here](https://github.com/ggerganov/whisper.cpp#quick-start).

### Running

Just simply run `./whisper11.rb` and it should start working.

## How it works

It should go in the loop of trying to get a voice input from the user by running `rec` command from the sox package. As it detects brief silence, it will cut the recording short, and pass it through Whisper to understand what you said. Then is passes that understood text input to ChatGPT, to elicit a response. Once it gets the response text, it will then try to generate voice using Eleven Labs or say command and play it back to you.

## Further improvements

- [ ] Make sure sox/rec always chooses the right input device. Does not always feel deterministic.
- [ ] Fine-tune sox/rec command to better detect silence.
- [ ] Get rid of sox-based input altogether. Using something lower-level, should allow for better control over when to cut.
- [ ] Allow keyboard input as well?
- [ ] LangChain integration

## License

MIT

## Brought to life by

[ForwardOperators](https://www.fwdoperators.com)

## Ruby?!

Yes.
