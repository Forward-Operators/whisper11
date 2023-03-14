class PromptGenerator
  def initialize(conversation)
    @conversation = conversation
  end

  def prefix
    "Use short sentences and be clear. Respond in English."
  end

  def generate
    prompt = prefix + "\n" + @conversation.prepare_context_prompt + "\n\n"

    # puts "Prompt generated:\n======================#{prompt}\n======================\n\n"

    prompt
  end
end
