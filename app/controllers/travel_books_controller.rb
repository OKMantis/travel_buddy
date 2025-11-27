class TravelBooksController < ApplicationController
  
  def create
    @current_user = current_user
    @activity = Activity.find(10)
    @message = @current_user.messages.last
    @chat = @current_user.chats.last
    @travel_book = TravelBook.create!(activity_id: @activity.id, message_id: @message.id)
    redirect_to chat_path(@chat)
  end

  private

  # def travel_book_params
  #   params.require(:travel_book).permit(:activity_id. :message_id)
  # end
end
