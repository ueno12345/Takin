class ChangeColumnNullOnUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :account_name, false
    change_column_null :users, :password, false
    change_column_null :users, :admin_flag, false
    change_column_default :users, :admin_flag, false
  end
end
