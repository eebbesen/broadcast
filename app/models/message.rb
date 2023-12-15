class Message < ApplicationRecord
  belongs_to :user
  validates :content, presence: true
  validates :status, presence: true
end
