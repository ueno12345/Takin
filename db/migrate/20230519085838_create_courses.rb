class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.integer :year
      t.string :term
      t.string :number
      t.string :name
      t.string :instructor
      t.integer :time_budget
      t.string :description

      t.timestamps
    end
  end
end
