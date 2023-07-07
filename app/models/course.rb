class Course < ApplicationRecord
  has_many :assignments, dependent: :destroy

  validates :year,
  numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :term,
  length: {maximum: 64}
  validates :number,
  format: {with: /\A[a-zA-Z0-9]{6}\z/, message: "は半角英数字6文字で入力してください"}
  validates :name,
  length: {maximum: 128}
  validates :instructor,
  length: {maximum: 128}
  validates :time_budget,
  numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :description,
  length: {maximum: 128} 

  def self.ransackable_attributes(auth_object = nil)
    ["year", "term", "number", "name", "instructor", "description", "assignment_course_name", "assignment_course_term", "work_hour_dtstart", "work_hour_dtend"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["assignments"]
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      course = find_by(year: row[1].to_i, number: row[3])
      if course
        course.update(year: row[1].to_i, term: row[2], number: row[3], name: row[4], instructor: row[5], time_budget: row[6], description: row[7])
      else
        course = self.new(year: row[1].to_i, term: row[2], number: row[3], name: row[4], instructor: row[5], time_budget: row[6], description: row[7])
        course.save
      end
    end
  end
end
