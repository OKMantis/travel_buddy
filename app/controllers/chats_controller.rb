class ChatsController < ApplicationController

  SYSTEM_PROMPT = "You are a Activities Assistant.\n\nI am a traveler , looking for activities to do in a chosen city.\n\nAnswer concisely in Markdown."
  
  def show
    @chat = current_user.chats.find(params[:id])
    @message = Message.new
  end

  def create
    @chat = Chat.new(chat_params)
    @chat.user = current_user
    @city = @chat.city
    @category = @chat.category
    @season = @chat.season
    @user_prompt = "Provide a list of activities in #{@city} that fit the category #{@category} " \
    "and are appropriate for the #{@season} season. Include only activities that " \
    "are realistically available in that city during that season. " \
    "Return the result as a list, and for each activity include: " \
    "- the activity name, " \
    "- a brief description, " \
    "- a direct link to its official or most relevant URL."

    ruby_llm_chat = RubyLLM.chat
    response = ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask(@user_prompt)
    Message.create(role: "user", content: @user_prompt, chat: @chat)
    Message.create(role: "assistant", content: response.content, chat: @chat)

    if @chat.save
      redirect_to chat_path(@chat)
    else
      render root_path
    end
  end


  private

  def chat_params
    params.require(:chat).permit(:city, :category, :season)
  end
end
