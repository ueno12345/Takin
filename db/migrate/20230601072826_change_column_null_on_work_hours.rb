class ChangeColumnNullOnWorkHours < ActiveRecord::Migration[7.0]
  def change
    change_column_null :work_hours, :dtstart, false
    change_column_null :work_hours, :dtend, false
    change_column_null :work_hours, :actual_working_minutes, false
  end
end
