class ChangeUsersEmailToBeNullable < ActiveRecord::Migration
  def change
    change_column :users, :email, :string, :null => true, :unique => false
    remove_index :users, :email
  end
end
