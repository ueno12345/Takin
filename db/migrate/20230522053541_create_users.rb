class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :account_name
      t.string :password
      t.boolean :admin_flag, null: false, default: false
      t.timestamps
    end
  end
end
