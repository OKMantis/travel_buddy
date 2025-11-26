class ChatsController < ApplicationController
  
  
  def show
    @chat = current_user.chats.find(params[:id])
    @message = Message.new
  end
  
  def create
    @activities = Activity
    .where(city: @city, category: @category, season: @season)
    .map do |activity|
      {
        id: activity.id,
        content: activity.content,
        category: activity.category,
        city: activity.city,
        season: activity.season
      }
    end
    @chat = Chat.new(chat_params)
    @chat.user = current_user
    @city = @chat.city
    @category = @chat.category
    @season = @chat.season
    @system_prompt = "You are a Activities Assistant.\n\nI am a traveler , looking for activities to do in a chosen city.\n\nProvide a list of activities in #{@city} that fit the category #{@category} and are appropriate for the #{@season} season. Include only the activities from this list: #{@activities}"
    @user_prompt = "Provide a list of activities"

    ruby_llm_chat = RubyLLM.chat
    response = ruby_llm_chat.with_instructions(@system_prompt).ask(@user_prompt)
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
