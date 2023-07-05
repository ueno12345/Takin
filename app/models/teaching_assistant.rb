class TeachingAssistant < ApplicationRecord
  has_many :assignments, dependent: :nullify

  def self.ransackable_attributes(auth_object = nil)
    ["year", "name", "number", "grade", "labo", "description"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["assignments"]
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      teaching_assistant = find_by(year: row[1].to_i, number: row[2])
      if teaching_assistant
        teaching_assistant.update(year: row[1].to_i, number: row[2], grade: row[3], name: row[4], labo: row[5], description: row[6])
      else
        teaching_assistant = self.new(year: row[1].to_i, number: row[2], grade: row[3], name: row[4], labo: row[5], description: row[6])
        teaching_assistant.save
      end
    end
  end
end
