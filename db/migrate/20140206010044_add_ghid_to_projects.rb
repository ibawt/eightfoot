class AddGhidToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :gh_id, :integer, :limit => 8
  end
end
