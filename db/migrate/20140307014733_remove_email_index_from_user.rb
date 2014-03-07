class RemoveEmailIndexFromUser < ActiveRecord::Migration
  def self.up
    remove_index :users, 'email'
    add_index :users, 'uid', unique: true
  end

  def self.down
    remove_index :users, 'uid'
    add_index :users, 'email', unique: true
  end
end
