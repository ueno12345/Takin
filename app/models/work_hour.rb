class WorkHour < ApplicationRecord
  belongs_to :assignment
  has_one :teaching_assistant, through: :assignment
  has_one :course, through: :assignment
  validates :dtstart, presence: true
  validates :dtend, comparison: {greater_than: :dtstart, message: "%{attribute}は開始時刻よりも後にして下さい"}, presence: true
  validates :actual_working_minutes, numericality: {in: 1..10000, message: "%{attribute}は1以上10000以下で入力してください"}, presence: true
  validate :no_overlap_with_existing_times, unless: -> { teaching_assistant.id == 1 }
  before_create :check_actual_working_minutes

  def date=(date)
    @date = date
  end

  def date
    @date || dtstart.try(:to_date)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["actual_working_minutes", "assignment_id", "created_at", "dtend", "dtstart", "id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["assignment"]
  end

  def no_overlap_with_existing_times
    existing_times = teaching_assistant.work_hours.where.not(id: id)

    existing_times.each do |existing_time|
      if overlap?(existing_time)
        errors.add(:base, "既存の勤務時間と重なっています")
        break
      end
    end
  end

  def check_actual_working_minutes
    time_budget = assignment.course.time_budget

    total_actual_working_minutes = assignment.course.work_hours.sum(:actual_working_minutes)

    total_actual_working_minutes += self.actual_working_minutes

    if total_actual_working_minutes > time_budget
      errors.add(:actual_working_minutes, "合計勤務時間が割当可能総時間を超えています")
      throw :abort
    end
  end

  private

  def overlap?(other_time)
    dtstart < other_time.dtend && other_time.dtstart < dtend
  end
end
