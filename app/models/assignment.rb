class Assignment < ApplicationRecord
  belongs_to :course
  belongs_to :teaching_assistant
  has_many :work_hours, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    ["course_id", "created_at", "description", "id", "teaching_assistant_id", "updated_at"]
  end


  def self.ransackable_associations(auth_object = nil)
    ["course","teaching_assistant", "work_hours"]
  end

end
