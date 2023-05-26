class ChangeColumnNullOnCourses < ActiveRecord::Migration[7.0]
  def change
      change_column_null :courses, :year, false
      change_column_null :courses, :term, false
      change_column_null :courses, :number, false
      change_column_null :courses, :name, false
      change_column_null :courses, :instructor, false
      change_column_null :courses, :time_budget, false
  end
end
