class TeachingAssistant < ApplicationRecord
  has_many :assignments, dependent: :nullify

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      teaching_assistant = find_by(id: row[0])
      if teaching_assistant
        teaching_assistant.update(year: row[1].to_i, number: row[2], name: row[3], grade: row[4], labo: row[5], description: row[6])
      else
        teaching_assistant = self.new(year: row[1].to_i, number: row[2], name: row[3], grade: row[4], labo: row[5], description: row[6])
        teaching_assistant.save
      end
    end
  end
end
