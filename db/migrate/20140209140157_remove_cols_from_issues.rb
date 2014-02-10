class RemoveColsFromIssues < ActiveRecord::Migration
  def change
    change_table :issues do |t|
      t.index [:project_id, :position]
      t.remove_index [:gh_id]
      t.index [:project_id, :gh_id]
    end
  end
end
