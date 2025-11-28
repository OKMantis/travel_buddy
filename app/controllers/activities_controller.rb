class ActivitiesController < ApplicationController
  
  def show
    @current_user = current_user
    @activity = Activity.find(params[:id])
    @message = Message.find(params[:message_id])
    @chat = @message.chat
    
    @travel_book = TravelBook.create!(activity_id: @activity.id, message_id: @message.id)
    update_link_text
    @message.save
    redirect_to chat_path(@chat)
  end

  private

  def update_link_text
    href = "<a class=\"\" href=\"/messages/#{params[:message_id]}/activities/#{params[:id]}\">Add to travelbook</a>"

    @message.content = @message.content.sub(href, "<span class=\"btn-link\" id=\"messages\/#{params[:message_id]}\/activities\/#{params[:id]}\">Saved!</span>")
  end

end
