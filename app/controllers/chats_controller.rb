class ChatsController < ApplicationController
  
  def show
    @chat    = current_user.chats.find(params[:id])
    @message = Message.new
  end

  def create
    @chat = Chat.new(chat_params)
    @chat.user = current_user

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
