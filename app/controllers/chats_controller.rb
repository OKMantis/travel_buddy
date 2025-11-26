class ChatsController < ApplicationController
  
  
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
    
    @system_instructions = "You are a Activities Assistant.\n\nI am a traveler , looking for activities to do in a chosen city."
    
    @system_prompt = "Provide a list of activities in #{@city} that fit the category #{@category} and are appropriate for the #{@season} season. Include only the activities from this list: #{@activities}"

    @user_message = "Provide a list of activities in #{@city} that fit the category #{@category} and are appropriate for the #{@season} season."
    

    ruby_llm_chat = RubyLLM.chat
    response = ruby_llm_chat.with_instructions(@system_instructions).ask(@system_prompt)
    Message.create(role: "user", content: @user_message, chat: @chat)
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
