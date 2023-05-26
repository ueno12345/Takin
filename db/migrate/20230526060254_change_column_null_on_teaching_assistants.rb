class ChangeColumnNullOnTeachingAssistants < ActiveRecord::Migration[7.0]
  def change
      change_column_null :teaching_assistants, :year, false
      change_column_null :teaching_assistants, :number, false
      change_column_null :teaching_assistants, :name, false
      change_column_null :teaching_assistants, :grade, false
      change_column_null :teaching_assistants, :labo, false
  end
end
