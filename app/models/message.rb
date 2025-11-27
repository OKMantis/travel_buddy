class Message < ApplicationRecord
  belongs_to :chat
  has_many :messages, dependent: :destroy
  has_many :travel_books
end
