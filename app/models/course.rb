class Course < ApplicationRecord
  has_many :assignments, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    ["year", "term", "number", "name", "instructor", "description", "assignment_course_name", "assignment_course_term", "work_hour_dtstart", "work_hour_dtend"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["assignments"]
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      course = find_by(id: row[0])
      if course
        course.update(year: row[1].to_i, term: row[2], number: row[3], name: row[4], instructor: row[5], time_budget: row[6], description: row[7])
      else
        course = self.new(year: row[1].to_i, term: row[2], number: row[3], name: row[4], instructor: row[5], time_budget: row[6], description: row[7])
        course.save
      end
    end
  end
end
