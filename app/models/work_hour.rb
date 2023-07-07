class WorkHour < ApplicationRecord
  belongs_to :assignment
  validates :dtstart, presence: true
  validates :dtend, presence: true

  validates :actual_working_minutes,
  numericality: {only_integer: true, greater_than_or_equal_to: 0}

  def self.ransackable_attributes(auth_object = nil)
    ["actual_working_minutes", "assignment_id", "created_at", "dtend", "dtstart", "id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["assignment"]
  end
end
