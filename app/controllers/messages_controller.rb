class MessagesController < ApplicationController
  SYSTEM_PROMPT = "You are a Activities Assistant.\n\nI am a traveler , looking for activities to do in a chosen city.\n\nAnswer concisely in Markdown."

  def create
    @chat = current_user.chats.find(params[:chat_id])
    #@chat.add
    #@message = Message.new(message_params)
    #@message.chat = @chat
    #@message.role = "user"
    @chat.with_instructions(SYSTEM_PROMPT).ask(message_params[:content])

    if @chat.save
      #Message.create(role: "assistant", content: response.content, chat: @chat)

      redirect_to chat_messages_path(@chat)
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
