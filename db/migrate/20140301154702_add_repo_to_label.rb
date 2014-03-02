class AddRepoToLabel < ActiveRecord::Migration
  def change
    add_column :labels, :repository_id, :integer
  end
end
