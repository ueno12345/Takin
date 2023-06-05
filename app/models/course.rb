class Course < ApplicationRecord
  has_many :assignments, dependent: :destroy

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      course = find_or_initialize_by(id: row[0])
      course.assign_attributes(year: row[1].to_i, term: row[2], number: row[3], name: row[4], instructor: row[5], time_budget: row[6], description: row[7])
      course.save unless course.persisted?
    end
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
