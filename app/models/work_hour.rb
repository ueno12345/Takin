class WorkHour < ApplicationRecord
  belongs_to :assignment
  validates :dtstart, presence: true
  validates :dtend, comparison: { greater_than: :dtstart, message: "%{attribute}は開始時刻よりも後にして下さい" }, presence: true
  validates :actual_working_minutes, numericality: {greater_than: 0}, presence: true

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

  def calc_work_hours(sum,hour)
    sum += hour
  end
end
