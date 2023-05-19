class TeachingAssistant < ApplicationRecord
  has_many :assignments, dependent: :nullify
end
