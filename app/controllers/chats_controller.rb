class ChatsController < ApplicationController


  def show
    @chat = current_user.chats.find(params[:id])
    @message = Message.new
  end

  def create

    @chat = Chat.new(chat_params)
    @chat.user = current_user
    @chat.title = "Untitled"
    @city = @chat.city
    @category = @chat.category
    @season = @chat.season
    
    @system_instructions = "You are a Activities Assistant.\n\nI am a traveler , looking for activities to do in a chosen city."
    
    @user_message = "Provide a list of activities in #{@city} that fit the category #{@category} and are appropriate for the #{@season} season."

    @user_message = Message.create(role: "user", content: @user_message, chat: @chat)
    @chat.generate_title_from_first_message

    ruby_llm_chat = RubyLLM.chat
    response = ruby_llm_chat.with_instructions(@system_instructions).ask(@chat.system_prompt(city: @city, category: @category, season: @season, message_id: @chat.messages.last.id + 1))
    Message.create(role: "assistant", content: response.content, chat: @chat)

    if @chat.save
      redirect_to chat_path(@chat)
    else
      render root_path
    end
  end

  def destroy
    @chat = Chat.find(params[:id])
    @chat.destroy
    redirect_to root_path
  end

  private

  def chat_params
    params.require(:chat).permit(:city, :category, :season)
  end
end
