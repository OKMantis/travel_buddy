class MessagesController < ApplicationController
  SYSTEM_PROMPT = "You are a Activities Assistant.\n\nI am a traveler , looking for activities to do in a chosen city.\n\nAnswer concisely in Markdown."

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @city = @chat.city
    @category = @chat.category
    @season = @chat.season
    # @activity_url = Activity.where()

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"
    ruby_llm_chat = RubyLLM.chat
    response = ruby_llm_chat
    .with_instructions(instructions).ask(
      "Provide a list of activities in #{@city} that fit the category #{@category} " \
      "and are appropriate for the #{@season} season. Include only activities that " \
      "are realistically available in that city during that season. " \
      "Return the result as a list, and for each activity include: " \
      "- the activity name, " \
      "- a brief description, " \
      "- a direct link to its official or most relevant URL."
    )
    Message.create(role: "assistant", content: response.content, chat: @chat)
    redirect_to chat_messages_path(@chat)

    if @message.save
      ruby_llm_chat = RubyLLM.chat
      response = ruby_llm_chat.with_instructions(instructions).ask(@message.content)
      # response = ruby_llm_chat.ask(@message.content)
      Message.create(role: "assistant", content: response.content, chat: @chat)

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