class AddGhidToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :gh_id, :integer, :limit => 8
    add_index :organizations, [:gh_id]
  end
end
