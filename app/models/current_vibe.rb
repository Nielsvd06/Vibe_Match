class CurrentVibe < ApplicationRecord
  belongs_to :user
  DEFAULT_TITLE = "Your Vibe"
end
