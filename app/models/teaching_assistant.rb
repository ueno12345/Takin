class TeachingAssistant < ApplicationRecord
  has_many :assignments, dependent: :nullify

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      teaching_assistant = find_or_initialize_by(id: row[0])
      teaching_assistant.assign_attributes(year: row[1].to_i, number: row[2], name: row[3], grade: row[4], labo: row[5], description: row[6])
      teaching_assistant.save unless teaching_assistant.persisted?
    end
  end
end
