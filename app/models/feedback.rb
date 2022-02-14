class Feedback < ApplicationRecord
  belongs_to :user

  validates :topic, :details, presence: true
end
