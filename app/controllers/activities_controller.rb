class ActivitiesController < ApplicationController
  
  def show
    @current_user = current_user
    @activity = Activity.find(params[:id])
    @message = Message.find(params[:message_id])
    
    @travel_book = TravelBook.create!(activity_id: @activity.id, message_id: @message.id)
    @chat = @message.chat
    redirect_to chat_path(@chat)
  end

end
