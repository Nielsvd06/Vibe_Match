class RecommendationsController < ApplicationController
  def index
  end

  def create
    # 1. when clicking on button "save and show rec."
    chat = RubyLLM.chat(model: "gpt-4o")
    @current_vibes = CurrentVibe.find(params[:current_vibe_id])

    @current_vibes.messages.order(:created_at).each do |message|
      chat.add_message(message)
    end

    movie_schema = {
      type: 'object',
      properties: {
        title: { type: 'string' },
        year: { type: 'integer' },
        description: { type: 'string' },
        r_rating: { type: 'integer' },
        r_reasoning: { type: 'string' }
      },
      required: ['title', 'year', 'description'],
      additionalProperties: false  # Required for OpenAI structured output
    }
    response = chat.ask("Based on our discussion recommend 3 movies, please.")

    # response = ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask(@message.content)
    Message.create(role: "assistant", content: response.content)
    @recommendation = Recommendation.create(r_reasoning: response.content, current_vibe_id: params[:current_vibe_id])
    redirect_to recommendation_path(@recommendation)

    # 2. new prompt: search all attributes needed for recommendations table
    #     and put them into a new json-file
    # 4. parse json-file
    # 3. copy data from json to recommendations-table
  end

  def show
    # 1. show the newest entry in recommendations table
    @recommendation = Recommendation.find(params[:id])
    # display poster, title, year, rating, reason movie was recommended
  end

  private

  def instructions

  end
end
