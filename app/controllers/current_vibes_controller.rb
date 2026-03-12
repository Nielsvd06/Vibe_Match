class CurrentVibesController < ApplicationController
  SYSTEM_PROMPT = <<~PROMPT
    You are a friendly assistant helping users choose a movie or TV show.

    Many people struggle to decide what to watch. Your job is to guide them through a short, natural conversation to understand their current vibe.

    A user's current vibe includes:
    - current mood
    - desired mood
    - energy level
    - available time

    Ask questions to understand ALL of these aspects. Ask ONE question at a time. Make sure you eventually cover mood, desired mood, energy level, and available time.

    Keep the questions conversational and natural, like a WhatsApp chat with a friend.

    The user also has a "main vibe", which describes their general viewing preferences. Use it only as background guidance when thinking about recommendations. Do NOT ask the user directly about it.

    Your goal is to gather enough information to make a good recommendation. Aim to do this within about 2–4 questions.

    Once you have enough information, tell the user you might have a great recommendation in mind. Then invite them to either:
    - generate a recommendation by clicking the button, or
    - continue the conversation to refine the recommendation.

    Do NOT reveal the recommendation yet.
    Avoid repeating questions if the user already answered them.
    Keep responses short, friendly, and conversational.
  PROMPT
  def create
    @current_vibe = CurrentVibe.new
    @current_vibe.user = current_user

    if @current_vibe.save
      # add LLM request passing through a system prompt to generate the first assistant message
      # call LLM to ask  intro questions
      ruby_llm_chat = RubyLLM.chat
      response = ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask("The user just opened the app. Start the conversation.")
      Message.create(role: "assistant", content: response.content, current_vibe: @current_vibe)

      redirect_to current_vibe_path(@current_vibe)
    else
      @current_vibes = @challenge.current_vibes.where(user: current_user)
      render "challenges/show"
    end
  end

  def show
    @current_vibe = current_user.current_vibes.find(params[:id])
    @message = Message.new
  end

  # def update
  # end
end

# current_vibe create action
# 1 - generate a blank current_vibe with titled as ‘untitled’ for example
# 2 - if @current_vibe.save statement
# 3 - make an LLM request passing through a system prompt to generate the first assistant message on the page.
#   (eg - let’s get started, in order to tailor your ideas we need to ask you some questions, firstly how much time do you have available?) and make a message in the back end ie: Message.create(content: response.content, role: ‘assistant’, current_vibe: @current_vibe)
# 4 - redirect to current_vibe show page

# add break to if loop for when user types/ triggers "create recommendation"
