class Chat < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy
  acts_as_chat
end
