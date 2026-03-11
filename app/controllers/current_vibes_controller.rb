class CurrentVibesController < ApplicationController
  def create
    @current_vibe = current_vibe.new(title: Current_Vibe::DEFAULT_TITLE)
    @current_vibe.user = current_user

    if @current_vibe.save
      # add LLM request passing through a system prompt to generate the first assistant message
      # call LLM to ask  intro questions
      ruby_llm_chat = RubyLLM.chat
      response = ruby_llm_chat.with_instructions(instructions).ask("Ask the user for their time availaible, energy level, current mood and desired mood")

      Message.create(role: "assistant", content: response.content, current_vibe: @current_vibe)

      redirect_to current_vibe_path(@current_vibe)
    else
      @current_vibes = @challenge.current_vibes.where(user: current_user)
      render "challenges/show"
    end
  end

  def show
    @chat    = current_user.chats.find(params[:id])
    @message = Message.new
  end

  def update
  end
end

# current_vibe create action
# 1 - generate a blank current_vibe with titled as ‘untitled’ for example
# 2 - if @current_vibe.save statement
# 3 - make an LLM request passing through a system prompt to generate the first assistant message on the page.
#   (eg - let’s get started, in order to tailor your ideas we need to ask you some questions, firstly how much time do you have available?) and make a message in the back end ie: Message.create(content: response.content, role: ‘assistant’, current_vibe: @current_vibe)
# 4 - redirect to current_vibe show page

# add break to if loop for when user types/ triggers "create recommendation"
