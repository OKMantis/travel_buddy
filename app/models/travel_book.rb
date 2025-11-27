class TravelBook < ApplicationRecord
  belongs_to :activity
  belongs_to :message
end
