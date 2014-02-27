class AddRowColWidthHeightToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :row, :integer
    add_column :issues, :col, :integer
    add_column :issues, :width, :integer
    add_column :issues, :height, :integer
    remove_column :issues, :position
  end
end
