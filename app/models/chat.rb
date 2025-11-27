class Chat < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy

  DEFAULT_TITLE = "Untitled"
  TITLE_PROMPT = <<~PROMPT
  Generate a short, descriptive, 3-to-6-word title that summarizes the user question for a chat conversation.
  PROMPT

  def generate_title_from_first_message
    return unless title == DEFAULT_TITLE

    first_user_message = messages.where(role: "user").order(:created_at).first
    return if first_user_message.nil?

    response = RubyLLM.chat.with_instructions(TITLE_PROMPT).ask(first_user_message.content)
    update(title: response.content)
  end

  def system_prompt(options: {:city, :category, :})
    return "Provide a list of activities in #{@city} that fit the category #{@category} and are appropriate for the #{@season} season. Include only the activities from this list: #{@activities}. Beside each activity ill need a html a tag with this format: '<a class=\"btn btn-primary ms-3\" href=\"/messages/message_id/activities/activity_id\">Add to travelbook</a>'. Ill provide the message id later so you can change it in the url. Use the activity id providda to change it in the url"
  end
end
