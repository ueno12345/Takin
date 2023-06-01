class ChangeColumnNullOnUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :account_name, null: false
    change_column_null :users, :password, null: false
    change_column_null :users, :admin_flag, null: false
    change_column_default :users, :admin_flag, null: false
    change_column :users, :admin_flag, :boolean
  end
end
