class WorkHour < ApplicationRecord
  belongs_to :assignment
  validates :dtstart, presence: true
  validates :dtend, presence: true
end
