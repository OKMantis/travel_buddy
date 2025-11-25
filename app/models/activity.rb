class Activity < ApplicationRecord
  # has_many :activity_messages

  SEASONS = [
    "Winter",
    "Spring",
    "Summer",
    "Fall"
  ]

  CITIES = [
    "New York",
    "Tokyo",
    "Barcelona",
    "Paris",
    "Dubai",
    "Cairo"
  ]

  CATEGORIES = [
    "Experiences & Activities",
    "Culture & Entertainment",
    "Family-Friendly",
    "Nightlife & Social",
    "Instagrammable Spots"
  ]
end
