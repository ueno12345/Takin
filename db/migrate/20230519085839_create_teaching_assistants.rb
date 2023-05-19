class CreateTeachingAssistants < ActiveRecord::Migration[7.0]
  def change
    create_table :teaching_assistants do |t|
      t.integer :year
      t.string :number
      t.string :name
      t.string :grade
      t.string :labo
      t.string :description

      t.timestamps
    end
  end
end
