class RecommendationsController < ApplicationController
  def index
    @current_vibe = CurrentVibe.find(params[:current_vibe_id])
    @recommendations = Recommendation.where(current_vibe: @current_vibe)
  end

  def create
    # 1. when clicking on button "save and show rec."
    chat = RubyLLM.chat(model: "gpt-4o")
    @current_vibe = CurrentVibe.find(params[:current_vibe_id])

    # llm here has no context about pass messages with the user
    # fix: let's pass them from the current_vibe.messages
    #  @current_vibe.messages.order(:created_at).each do |msg|
    #   chat.add_message(msg)
    # end
    #
    prompt = <<~PROMPT
      Based on our discussion, recommend 3 movies.

      You must respond strictly with valid JSON matching the following schema:
      {
        type: 'object',
        properties: {
          recommendations: {
            type: 'array',
            items: {
              type: 'object',
              properties: {
                title: { type: 'string' },
                year: { type: 'integer' },
                description: { type: 'string' },
                r_rating: { type: 'integer' },
                r_reasoning: { type: 'string' }
              },
              required: ['title', 'year', 'description', 'r_rating', 'r_reasoning'],
            }
          }
        }
        required: ['recommendations']
      }
      Return ONLY the JSON object, absolutely no markdown formatting like ```json.
    PROMPT

    # the LLM request in the here is completely disconnected from the conversation the user just had
    # in Ruby, string interpolation of an AR object just calls to_s on the instance
    response = chat.ask(prompt)

    parsed_data = JSON.parse(response.content)
    @recommendations = parsed_data["recommendations"].map do |movie_data|
      Recommendation.create!(
        current_vibe: @current_vibe,
        title: movie_data['title'],
        description: movie_data['description'],
        year: movie_data['year'],
        r_rating: movie_data['r_rating'],
        r_reasoning: response.content
      )
    end

    # response = ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask(@message.content)
    Message.create(role: "assistant", content: response.content)
    redirect_to current_vibe_recommendations_path(@current_vibe)

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
