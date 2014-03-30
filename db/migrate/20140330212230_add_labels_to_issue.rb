class AddLabelsToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :labels, :text
  end
end
