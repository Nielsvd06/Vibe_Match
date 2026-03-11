class CurrentVibesController < ApplicationController
  def index
  end

  def show
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
