class AddTokenColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :token, :string
    add_column :users, :expires, :boolean
  end
end
