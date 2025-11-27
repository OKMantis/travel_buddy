class Message < ApplicationRecord
  belongs_to :chat
  has_many :travel_books, dependent: :destroy
  has_many :activities, through: :travel_books
  
end
