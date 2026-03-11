class MessagesController < ApplicationController
  def create
    @current_vibe = current_user.current_vibes.find(params[:current_vibe_id])
    @message = Message.new(message_params)
    @message.role = "user"
    @current_vibe = @message.current_vibe
      if @message.save
        ruby_llm_chat = RubyLLM.chat
        response = ruby_llm_chat.with_instructions(instructions).ask(@message.content)

        Message.create(role: "assistant", content: response.content, current_vibe: @current_vibe)

        @current_vibe.generate_title_from_first_message

        redirect_to current_vibes_path(@current_vibe)
      else
        render "current_vibes/show", status: :unprocessable_entity
      end
  end
end

# add the System_Prompt
system_prompt = <<~TEXT
Your persona is to act as an emotionally supportive assistant for making movies and/or series recommendations.
The context is that sometimes it is difficult to decide what to watch and with help from you, the user will get there.
Your task is to help guide the users in their decision to choose a movie and/or series based on their current mood(current_vibe)
The output expected is an exchange of messages until all 4 questions are asked to make your recommendation.
TEXT

# Remember that a good prompt should include:
# Persona: Who should the AI act as?
# Context: What the output will be used for and by whom (i.e. the user), and any relevant data to pass along the user input.
# Task: usually defined by the user, but it should be clear, direct and specific.
# Format: How the output should be structured (e.g. JSON, Markdown, etc.).


# Messages create action
# check class notes here: https://github.com/lewagon/rails-ai-challenges/blob/before-conversational-ux/app/controllers/messages_controller.rb
# 1 - find the current_vibe from the url params
# 2 - create new Message passing the content from message_params
# 3 - assign role of message as ‘user’
# 4 - assign current_vibe instance to message.current_vibe
# 5 - if message.save statement

# 6 - if the message saves, we trigger an update of the current_vibe (add to class code) based off the users message. eg current_vibe.update(duration: message.content)
# 7 - also if the messages saves need to generate the next AI question (ie generate next assistant role message) (edited)
