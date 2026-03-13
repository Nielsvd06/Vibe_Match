class CurrentVibesController < ApplicationController
  def create
    @current_vibe = CurrentVibe.new
    @current_vibe.user = current_user

    if @current_vibe.save
      # add LLM request passing through a system prompt to generate the first assistant message
      # call LLM to ask  intro questions
      ruby_llm_chat = RubyLLM.chat
      response = ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask("The user just opened the app. Start the conversation with a brief question.")
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
end
