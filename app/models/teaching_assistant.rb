class TeachingAssistant < ApplicationRecord
  has_many :assignments, dependent: :nullify
  has_many :work_hours, through: :assignments

  validates :year,
  numericality: {in: 1..10000, message: "%{attribute}は1以上10000以下で入力してください"},
  presence: true
  validates :number,
  format: {with: /\A[a-zA-Z0-9]{8}\z/, message: "%{attribute}は半角英数字8文字で入力してください"},
  presence: true
  validates :grade,
  length: {is: 2, wrong_length: "%{attribute}は%{count}文字で入力してください"},
  format: {with: /\A[M|D]/, message: "%{attribute}はMまたはDで始まる必要があります"},
  presence: true
  validates :name,
  length: {maximum: 128, too_long: "%{attribute}は%{count}文字以内で入力してください"},
  presence: true
  validates :labo,
  length: {maximum: 128, too_long: "%{attribute}は%{count}文字以内で入力してください"}
  validates :description,
  length: {maximum: 128, too_long: "%{attribute}は%{count}文字以内で入力してください"}

  def self.ransackable_attributes(auth_object = nil)
    ["year", "name", "number", "grade", "labo", "description"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["assignments"]
  end

  def self.import(file)
    return if file.nil?

    CSV.foreach(file.path, headers: true) do |row|
      teaching_assistant = find_by(year: row[1].to_i, number: row[2])
      if teaching_assistant
        #teaching_assistant.update(year: row[1].to_i, number: row[2], grade: row[3], name: row[4], labo: row[5], description: row[6])
      else
        teaching_assistant = self.new(year: row[1].to_i, number: row[2], grade: row[3], name: row[4], labo: row[5], description: row[6])
        teaching_assistant.save
        @teaching_assistant_import_flag = true
      end
    end
    return @teaching_assistant_import_flag
  end
end
