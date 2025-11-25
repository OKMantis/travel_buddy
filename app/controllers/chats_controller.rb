class ChatsController < ApplicationController
  def create
    @chat = Chat.new(chat_params)
    @chat.user = current_user

    if @chat.save
      redirect_to chat_path(@chat)
    else
      render "challenges/show"
    end
  end

  def show
    @chat    = current_user.chats.find(params[:id])
    @message = Message.new
  end

  private

  def chat_params
    params.require(:chat).permit(:city, :category, :season)
  end
end
