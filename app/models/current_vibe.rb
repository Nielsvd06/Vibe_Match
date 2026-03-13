class CurrentVibe < ApplicationRecord
  belongs_to :user
  has_many :messages
  has_many :recommendations
end
