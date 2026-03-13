class MessagesController < ApplicationController
  def create
    @current_vibe = current_user.current_vibes.find(params[:current_vibe_id])
    @message = Message.new(message_params)
    @message.role = "user"
    @message.current_vibe = @current_vibe
    if @message.save
      @ruby_llm_chat = RubyLLM.chat
      build_conversation_history

      response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)

      Message.create(
        role: "assistant",
        content: response.content,
        current_vibe: @current_vibe
      )

      # @current_vibe.generate_title_from_first_message

      redirect_to current_vibes_path(@current_vibe)
    else
      render "current_vibes/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def instructions
    main_vibes =
      "I am in my thirties,
      I like all genres,
      I go for ratings above 7/10 only,
      language preference is english content."
    [
      SYSTEM_PROMPT,
      main_vibes
    ].compact.join("\n\n")
  end

  def build_conversation_history
    @current_vibe.messages.each do |message|
      @ruby_llm_chat.add_message(message)
    end
  end
end

#

# Remember that a good prompt should include:
# Persona: Who should the AI act as?
# Context: What the output will be used for and by whom (i.e. the user), and any relevant data to pass along the user input.
# Task: usually defined by the user, but it should be clear, direct and specific.
# Format: Provide me the five movies as json with imdb rating How the output should be structured (e.g. JSON, Markdown, etc.).

# Messages create action
# check class notes here: https://github.com/lewagon/rails-ai-challenges/blob/before-conversational-ux/app/controllers/messages_controller.rb
# 1 - find the current_vibe from the url params
# 2 - create new Message passing the content from message_params
# 3 - assign role of message as ‘user’
# 4 - assign current_vibe instance to message.current_vibe
# 5 - if message.save statement
# 6 - if the message saves, we trigger an update of the current_vibe (add to class code) based off the users message. eg current_vibe.update(duration: message.content)
# 7 - also if the messages saves need to generate the next AI question (ie generate next assistant role message) (edited)
