class Course < ApplicationRecord
  has_many :assignments, dependent: :destroy
  has_many :work_hours, through: :assignments

  validates :year,
  numericality: {only_integer: true, greater_than: 0},
  presence: true
  validates :term,
  length: {maximum: 64, too_long: "%{attribute}は%{count}文字以下で入力してください"}
  validates :number,
  format: {with: /\A[a-zA-Z0-9]{6}\z/, message: "%{attribute}は半角英数字6文字で入力してください"},
  presence: true
  validates :name,
  length: {maximum: 128, too_long: "%{attribute}は%{count}文字以下で入力してください"},
  presence: true
  validates :instructor,
  length: {maximum: 128, too_long: "%{attribute}は%{count}文字以下で入力してください"},
  presence: true
  validates :time_budget,
  numericality: {only_integer: true, greater_than: 0},
  presence: true
  validates :description,
  length: {maximum: 128, too_long: "%{attribute}は%{count}文字以下で入力してください"}

  def self.ransackable_attributes(auth_object = nil)
    ["year", "term", "number", "name", "instructor", "description", "assignment_course_name", "assignment_course_term", "work_hour_dtstart", "work_hour_dtend"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["assignments"]
  end

  def self.import(file)
    return if file.nil?

    CSV.foreach(file.path, headers: true) do |row|
      course = find_by(year: row[1].to_i, number: row[3])
      if course
        course.update(year: row[1].to_i, term: row[2], number: row[3], name: row[4], instructor: row[5], time_budget: row[6], description: row[7])
      else
        course = self.new(year: row[1].to_i, term: row[2], number: row[3], name: row[4], instructor: row[5], time_budget: row[6], description: row[7])
        course.save
        @assignment = Assignment.new({course_id:course.id, teaching_assistant_id:"1", description:"dammy"})
        @assignment.save
      end
    end
  end
end
