class WorkHour < ApplicationRecord
  belongs_to :assignment

  def self.ransackable_attributes(auth_object = nil)
    ["actual_working_minutes", "assignment_id", "created_at", "dtend", "dtstart", "id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["assignment"]
  end
end
