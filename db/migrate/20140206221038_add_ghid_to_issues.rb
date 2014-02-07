class AddGhidToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :gh_id, :integer, :limit => 8
    add_index :issues, [:gh_id]
  end
end
