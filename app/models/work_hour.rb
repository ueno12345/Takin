class WorkHour < ApplicationRecord
  belongs_to :assignment
  has_one :teaching_assistant, through: :assignment
  validates :dtstart, presence: true
  validates :dtend, comparison: { greater_than: :dtstart, message: "%{attribute}は開始時刻よりも後にして下さい" }, presence: true
  validates :actual_working_minutes, numericality: {greater_than: 0}, presence: true
  validate :no_overlap_with_existing_times, unless: -> { teaching_assistant.id == 1 }

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

  def no_overlap_with_existing_times
    existing_times = teaching_assistant.work_hours.where.not(id: id) # 編集中の勤務時間を除外

    existing_times.each do |existing_time|
      if overlap?(existing_time)
        errors.add(:base, "既存の勤務時間と重なっています")
        break
      end
    end
  end

  private

  def overlap?(other_time)
    dtstart <= other_time.dtend && other_time.dtstart <= dtend
  end
end
