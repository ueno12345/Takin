class CreateAssignments < ActiveRecord::Migration[7.0]
  def change
    create_table :assignments do |t|
      t.references :course, null: false, foreign_key: true
      t.references :teaching_assistant, null: false, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
