class AddProjectConfigVarsForIssueCountLabelDisplay < ActiveRecord::Migration
  def change
    add_column :projects, :max_issues, :integer, limit:  8, default: 100
    add_column :projects, :display_labels, :boolean, default: false
  end
end
