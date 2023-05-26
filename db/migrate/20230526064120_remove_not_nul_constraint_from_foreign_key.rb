class RemoveNotNulConstraintFromForeignKey < ActiveRecord::Migration[7.0]
  def change
    change_column_null :assignments, :teaching_assistant_id, true
  end
end
