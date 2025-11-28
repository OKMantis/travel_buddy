class Chat < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy

  attr_accessor :city

  validate :city_must_be_present_for_ai_chat

  DEFAULT_TITLE = "Untitled"
  TITLE_PROMPT = <<~PROMPT
  Generate a short, descriptive, 3-to-6-word title that summarizes the user question for a chat conversation.
  PROMPT

  def generate_title_from_first_message
    return unless title == DEFAULT_TITLE

    first_user_message = messages.where(role: "user").order(:created_at).first
    return if first_user_message.nil?

    response = RubyLLM.chat.with_temperature(0).with_instructions(TITLE_PROMPT).ask(first_user_message.content)
    update(title: response.content)
  end

  def system_prompt(city: "", category: "", season: "", message_id: nil)
    activities = Activity.all
    prompt = "Provide a list of activities in ul form, where each li tag has the activity id "
    
    if city.present?
      activities = activities.where(city: city)
      prompt += " in #{city}"
    end

    if category.present?
      activities = activities.where(category: category)
      prompt += " where activity category is #{category}"
    end

    if season.present?
      activities = activities.where(season: season)
      prompt += " and season is #{season}"
    end


    activities.map do |activity|
      {
        id: activity.id,
        content: activity.content,
        category: activity.category,
        city: activity.city,
        season: activity.season
      }
    end

    a_tag = "<a class=\"\" href=\"/messages/message_id/activities/activity_id\">Add to travelbook</a>"

    prompt += " and insert next to each activity a html a tag with this format: #{a_tag}. In the href attribute replace `message_id` with #{message_id}."
    prompt += activities.to_json
  end

  private

  def city_must_be_present_for_ai_chat
    return unless city.blank? && errors.empty?
    errors.add(:city, "can't be blank — please enter a destination")
  end
end
