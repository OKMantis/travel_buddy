class Activity < ApplicationRecord
  # has_many :activity_messages

  SEASON = [
    "Winter",
    "Spring",
    "Summer",
    "Fall"
  ]

  CITY = [
    "New York",
    "Barcelona",
    "Tokyo"
  ]

  CATEGORY = [
    "Experiences & Activities",
    "Culture & Entertainment",
    "Family-Friendly",
    "Nightlife & Social",
    "Instagrammable Spots"
  ]
end
