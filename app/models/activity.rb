class Activity < ApplicationRecord
  has_many :travel_books

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
