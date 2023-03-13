class Conversation
  def initialize
    @statements = []
  end

  def remember_my_statement(statement)
    @statements << ['ME', statement]
  end

  def remember_generated_statement(statement)
    @statements << ['YOU', statement]
  end

  def remember_statement(who, statement)
    @statements << [who, statement]
  end

  def prepare_context_prompt
    prompt = "\nWe are in a conversation and here's so far what was said for context. Please omit the \"YOU\" and \"ME\" words in response: \n\n"

    @statements.each do |who, statement|
      prompt += "#{who}: #{statement}
      
"
    end

    prompt += "YOU: "

    prompt
  end
end
