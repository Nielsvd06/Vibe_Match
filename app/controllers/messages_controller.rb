class MessagesController < ApplicationController
  def create
    @current_vibe = current_user.current_vibes.find
  end
end

# add the System_Prompt

# Messages create action
# check class notes here: https://github.com/lewagon/rails-ai-challenges/blob/before-conversational-ux/app/controllers/messages_controller.rb
# 1 - find the current_vibe from the url params
# 2 - create new Message passing the content from message_params
# 3 - assign role of message as ‘user’
# 4 - assign current_vibe instance to message.current_vibe
# 5 - if message.save statement
# 
# 6 - if the message saves, we trigger an update of the current_vibe (add to class code) based off the users message. eg current_vibe.update(duration: message.content)
# 7 - also if the messages saves need to generate the next AI question (ie generate next assistant role message) (edited)

# current_vibe create action
# 1 - generate a blank current_vibe with titled as ‘untitled’ for example
# 2 - if @current_vibe.save statement
# 3 - make an LLM request passing through a system prompt to generate the first assistant message on the page.
#   (eg - let’s get started, in order to tailor your ideas we need to ask you some questions, firstly how much time do you have available?) and make a message in the back end ie: Message.create(content: response.content, role: ‘assistant’, current_vibe: @current_vibe)
# 4 - redirect to current_vibe show page
