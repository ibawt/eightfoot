class AddTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :type, :string, :null => false, :default => "RegularUser"
  end
end
