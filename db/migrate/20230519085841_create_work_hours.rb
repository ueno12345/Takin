class CreateWorkHours < ActiveRecord::Migration[7.0]
  def change
    create_table :work_hours do |t|
      t.datetime :dtstart
      t.datetime :dtend
      t.integer :actual_working_minutes
      t.references :assignment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
