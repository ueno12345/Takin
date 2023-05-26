class Assignment < ApplicationRecord
  belongs_to :course
  belongs_to :teaching_assistant
  has_many :work_hours, dependent: :destroy
end
